//
//  ToastPriority.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

public enum ToastPriority: Int, Comparable {
    case highest = 1, high = 2, medium = 3, low = 4, lowest = 5
    public static func < (lhs: ToastPriority, rhs: ToastPriority) -> Bool { lhs.rawValue < rhs.rawValue }
}
