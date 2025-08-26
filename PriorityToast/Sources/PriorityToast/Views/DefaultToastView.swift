//
//  DefaultToastView.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

public final class DefaultToastView: UIView, ToastViewProtocol {
    private let container = UIStackView()
    private let messageLabel = UILabel()
    private var style: ToastStyle = DefaultToastStyle()
    private var accessoryView: UIView? = nil

    public init(style: ToastStyle = DefaultToastStyle()) {
        super.init(frame: .zero)
        self.style = style
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        if let borderColor = style.borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 1.0
        } else {
            layer.borderWidth = 0
        }
        
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = style.font
        messageLabel.textColor = style.textColor
        
        if let accessory = accessoryView {
            configureAccessoryView(accessory)
        }

        container.addArrangedSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: style.padding.top),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.padding.left),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -style.padding.right),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.padding.bottom),
            widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 80)
        ])
    }

    public func setAccessoryView(_ view: UIView) {
        if let old = accessoryView {
            container.removeArrangedSubview(old)
            old.removeFromSuperview()
        }
        accessoryView = view
        configureAccessoryView(view)
        container.insertArrangedSubview(view, at: 0)
    }

    private func configureAccessoryView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if let imageView = view as? UIImageView {
            imageView.tintColor = style.accessoryColor
        } else {
            view.tintColor = style.accessoryColor
        }
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 24),
            view.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    public func configure(with item: ToastItem) { messageLabel.text = item.message }
    
    public func showAnimation(completion: @escaping () -> Void) {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: { _ in completion() })
    }
    
    public func dismissAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: 20)
        }, completion: { _ in completion() })
    }
}
