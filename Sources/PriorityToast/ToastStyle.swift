//
//  ToastStyle.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

public protocol ToastStyle {
    var backgroundColor: UIColor { get }
    var borderColor: UIColor? { get }
    var accessoryColor: UIColor { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
    var cornerRadius: CGFloat { get }
    var padding: UIEdgeInsets { get }
}
