//
//  ToastItem.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import Foundation

@MainActor
public struct ToastItem: Equatable {
    public let id = UUID()
    public let message: String
    public let priority: ToastPriority
    public let duration: TimeInterval
    public let view: ToastViewProtocol
    
    public init(
        message: String,
        priority: ToastPriority,
        duration: TimeInterval = 2.0,
        view: ToastViewProtocol = DefaultToastView()
    ) {
        self.message = message
        self.priority = priority
        self.duration = duration
        self.view = view
    }
    
    nonisolated public static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
        return lhs.id == rhs.id
    }
}
