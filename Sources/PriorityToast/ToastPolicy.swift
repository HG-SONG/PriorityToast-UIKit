//
//  ToastPolicy.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

/// 토스트 큐에서 기존 토스트를 처리할 때 적용되는 정책
/// Policy for handling existing toasts in the queue
public enum ToastPolicy {
    /// 버림: 더 높은 우선순위 토스트가 들어오면 기존 토스트는 즉시 제거됨
    /// Discard: existing toast is immediately removed when a higher priority toast arrives
    case discard

    /// 재큐잉: 더 높은 우선순위 토스트가 들어오면 기존 토스트는 나중에 다시 보여주기 위해 큐에 재등록됨
    /// Requeue: existing toast is re-enqueued to be shown later after higher priority toasts
    case requeue
}
