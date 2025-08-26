//
//  ToastViewProtocol.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

public protocol ToastViewProtocol: UIView {
    func configure(with item: ToastItem)
    func showAnimation(completion: @escaping () -> Void)
    func dismissAnimation(completion: @escaping () -> Void)
}
