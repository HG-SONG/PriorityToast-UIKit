//
//  DefaultToastStyle.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

public struct DefaultToastStyle: ToastStyle {
    public var backgroundColor: UIColor
    public var borderColor: UIColor?
    public var accessoryColor: UIColor
    public var textColor: UIColor
    public var font: UIFont
    public var cornerRadius: CGFloat
    public var padding: UIEdgeInsets
    
    public init(
        backgroundColor: UIColor = .black, borderColor: UIColor? = nil,
        accessoryColor: UIColor = .white, textColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 14), cornerRadius: CGFloat = 8,
        padding: UIEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.accessoryColor = accessoryColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
}
