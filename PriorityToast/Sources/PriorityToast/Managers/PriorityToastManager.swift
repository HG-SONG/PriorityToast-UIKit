//
//  PriorityToastManager.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

@MainActor
public final class PriorityToastManager {
    public static let shared = PriorityToastManager()
    
    private var currentToast: ToastItem?
    private var queue: [ToastItem] = []
    private var policy: ToastPolicy = .discard
    private var isPresenting = false
    private var currentPresentationTask: Task<Void, Never>?
    
    private init() {}
    
    // MARK: - Config
    public func configure(policy: ToastPolicy) {
        self.policy = policy
    }
    
    // MARK: - Public API
    public func show(_ toast: ToastItem) async {
        // 1. 현재 표시 중인 토스트가 있는지 확인
        if let current = currentToast {
            // 2. 새로 들어온 토스트가 현재 토스트보다 우선순위가 높은지 확인
            if toast.priority < current.priority {
                // 새치기 발생!
                switch policy {
                case .discard:
                    // 현재 토스트 버리고 새 토스트 추가
                    enqueue(toast)
                    await dismissCurrent()
                    // 현재 토스트를 큐에서 제거 (discard 정책)
                    queue.removeAll { $0.id == current.id }
                    await presentNext()
                case .requeue:
                    // 현재 토스트를 큐에 다시 넣고 새 토스트 추가
                    enqueue(toast)
                    enqueue(current) // 현재 것 다시 큐에
                    await dismissCurrent()
                    await presentNext()
                }
            } else {
                // 우선순위가 낮거나 같으면 그냥 큐에서 대기
                enqueue(toast)
            }
        } else {
            // 현재 표시 중인 토스트가 없으면 큐에 추가하고 바로 표시
            enqueue(toast)
            await presentNext()
        }
    }
    
    // MARK: - Queue
    private func enqueue(_ toast: ToastItem) {
        queue.append(toast)
        queue.sort { $0.priority < $1.priority }
    }
    
    // MARK: - Presentation
    private func presentNext() async {
        guard !isPresenting, let next = queue.first else { return }
        
        isPresenting = true
        currentToast = next
        
        // 현재 토스트 표시 Task 생성
        currentPresentationTask = Task {
            // Presenter에 토스트 표시 (애니메이션만)
            await ToastPresenter.showToast(next)
            
            // duration만큼 대기 (여기서 취소 가능)
            do {
                try await Task.sleep(nanoseconds: UInt64(next.duration * 1_000_000_000))
            } catch is CancellationError {
                // 새치기로 인한 취소 - 정상적인 상황
                return
            } catch {
                // 기타 에러
                return
            }
            
            // 자연스러운 종료 (새치기가 없었던 경우)
            if !Task.isCancelled {
                await ToastPresenter.dismissToast(next.id)
                // 완료된 토스트를 큐에서 제거
                queue.removeAll { $0 == next }
                currentToast = nil
                isPresenting = false
                currentPresentationTask = nil
                
                // 다음 토스트 표시
                await presentNext()
            }
        }
        
        await currentPresentationTask?.value
    }
    
    private func dismissCurrent() async {
        guard let currentToast = currentToast else { return }
        
        // 현재 표시 Task 취소
        currentPresentationTask?.cancel()
        
        // 토스트 즉시 제거
        await ToastPresenter.dismissToast(currentToast.id)
        
        // 상태 정리
        self.currentToast = nil
        isPresenting = false
        currentPresentationTask = nil
    }
}
