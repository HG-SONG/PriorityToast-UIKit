//
//  PriorityToastManager.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

@MainActor
public final class PriorityToastManager {
    public static let shared = PriorityToastManager()
    
    private var currentToast: ToastItem?
    private var queue: [ToastItem] = []
    private var policy: ToastPolicy = .discard
    
    private init() {}
    
    public func configure(policy: ToastPolicy) {
        self.policy = policy
    }
    
    @MainActor
    public func show(_ toast: ToastItem) {
        if let current = currentToast {
            if toast.priority < current.priority {
                switch policy {
                case .discard:
                    dismissCurrent()
                    present(toast)
                case .requeue:
                    enqueue(current)
                    dismissCurrent()
                    present(toast)
                }
            } else {
                enqueue(toast)
            }
        } else {
            present(toast)
        }
    }
    
    private func enqueue(_ toast: ToastItem) {
        queue.append(toast)
        queue.sort { $0.priority < $1.priority }
    }
    
    @MainActor
    private func present(_ toast: ToastItem) {
        currentToast = toast
        ToastPresenter.show(toast) { [weak self] in
            self?.currentToast = nil
            if let next = self?.queue.first {
                self?.queue.removeFirst()
                self?.present(next)
            }
        }
    }
    
    @MainActor
    private func dismissCurrent() {
        ToastPresenter.dismiss()
        currentToast = nil
    }
}
