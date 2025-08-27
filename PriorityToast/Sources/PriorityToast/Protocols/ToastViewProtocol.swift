//
//  ToastViewProtocol.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

public protocol ToastViewProtocol: UIView {
    func setAccessoryView(_ view: UIView?)
    func configure(with item: ToastItem)
    func showAnimation(duration: TimeInterval) async
    func dismissAnimation() async
}
