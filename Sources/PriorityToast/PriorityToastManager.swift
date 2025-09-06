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
    
    var currentToast: ToastItem?
    var queue: [ToastItem] = []
    private var policy: ToastPolicy = .discard
    private var isPresenting = false
    private var currentPresentationTask: Task<Void, Never>?
    
    private init() {}
    
    // MARK: - Config
    // 정책 설정 (Set toast policy)
    public func configure(policy: ToastPolicy) {
        self.policy = policy
    }
    
    // MARK: - Public API
    public func show(_ toast: ToastItem) async {
        // 1. 현재 표시 중인 토스트가 있는지 확인
        // 1. Check if there is a toast currently being displayed
        if let current = currentToast {
            // 2. 새로 들어온 토스트가 현재 토스트보다 우선순위가 높은지 확인
            // 2. Check if the new toast has higher priority than the current one
            if toast.priority < current.priority {
                // 새치기 발생!
                // Preemption occurs!
                switch policy {
                case .discard:
                    // 현재 토스트 버리고 새 토스트 추가
                    // Discard current toast and add the new one
                    enqueue(toast)
                    await dismissCurrent()
                    // 현재 토스트를 큐에서 제거 (discard 정책)
                    // Remove the current toast from queue (discard policy)
                    queue.removeAll { $0.id == current.id }
                    await presentNext()
                case .requeue:
                    // 현재 토스트를 큐에 다시 넣고 새 토스트 추가
                    // Requeue current toast and add the new one
                    enqueue(toast)
                    await dismissCurrent()
                    await presentNext()
                }
            } else {
                // 우선순위가 낮거나 같으면 그냥 큐에서 대기
                // If priority is lower or equal, just enqueue
                enqueue(toast)
            }
        } else {
            // 현재 표시 중인 토스트가 없으면 큐에 추가하고 바로 표시
            // If no toast is currently shown, enqueue and present immediately
            enqueue(toast)
            await presentNext()
        }
    }
    
    // MARK: - Queue
    // 토스트를 큐에 추가 (Add toast to queue)
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
        // Create Task to display current toast
        currentPresentationTask = Task {
            // Presenter에 토스트 표시 (애니메이션만)
            // Show toast in Presenter (only animation)
            await ToastPresenter.showToast(next)
            
            // duration만큼 대기 (여기서 취소 가능)
            // Wait for duration (can be cancelled here)
            do {
                try await Task.sleep(nanoseconds: UInt64(next.duration * 1_000_000_000))
            } catch is CancellationError {
                // 새치기로 인한 취소 - 정상적인 상황
                // Cancelled due to preemption - normal case
                return
            } catch {
                // 기타 에러
                // Other error
                return
            }
            
            // 자연스러운 종료 (새치기가 없었던 경우)
            // Normal dismissal (when no preemption happened)
            if !Task.isCancelled {
                await ToastPresenter.dismissToast(next.id)
                // 완료된 토스트를 큐에서 제거
                // Remove completed toast from queue
                queue.removeAll { $0 == next }
                currentToast = nil
                isPresenting = false
                currentPresentationTask = nil
                
                // 다음 토스트 표시
                // Show next toast
                await presentNext()
            }
        }
        
        await currentPresentationTask?.value
    }
    
    private func dismissCurrent() async {
        guard let currentToast = currentToast else { return }
        
        // 현재 표시 Task 취소
        // Cancel current presentation Task
        currentPresentationTask?.cancel()
        
        // 토스트 즉시 제거
        // Dismiss toast immediately
        await ToastPresenter.dismissToast(currentToast.id)
        
        // 상태 정리
        // Reset state
        self.currentToast = nil
        isPresenting = false
        currentPresentationTask = nil
    }
    
    // MARK: - Clear
    public func clearAll() async {
        // 현재 표시 중인 토스트 제거
        // Remove currently displayed toast
        currentPresentationTask?.cancel()
        if let currentToast = currentToast {
            await ToastPresenter.dismissToast(currentToast.id)
        }
        
        // 상태 초기화
        // Reset state
        currentToast = nil
        isPresenting = false
        currentPresentationTask = nil
        queue.removeAll()
    }
}
