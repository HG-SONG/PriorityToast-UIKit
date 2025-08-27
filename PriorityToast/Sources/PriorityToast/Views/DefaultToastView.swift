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
    private var accessoryView: UIView?

    public init(style: ToastStyle = DefaultToastStyle()) {
        super.init(frame: .zero)
        self.style = style
        self.accessoryView = CircularProgressView(
            progressColor: style.accessoryColor,
            backgroundColor: .clear,
            lineWidth: 3
        )
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
            setAccessoryView(accessory)
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

    public func setAccessoryView(_ view: UIView?) {
        if let old = accessoryView {
            container.removeArrangedSubview(old)
            old.removeFromSuperview()
        }
        accessoryView = view
        guard let view = view else { return }
        
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

    public func configure(with item: ToastItem) {
        messageLabel.text = item.message
    }
    
    public func showAnimation(duration: TimeInterval) async {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: 20)
        if let circularView = self.accessoryView as? CircularProgressView {
            circularView.startAnimation(duration: duration, from: 0.0, to: 1.0)
        }

        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
                self.transform = .identity
            }, completion: { _ in
                continuation.resume()
            })
        }
    }
    
    public func dismissAnimation() async {
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(translationX: 0, y: 20)
            }, completion: { _ in
                continuation.resume()
            })
        }
    }
}
