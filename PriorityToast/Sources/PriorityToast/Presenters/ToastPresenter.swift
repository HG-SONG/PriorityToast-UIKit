//
//  ToastPresenter.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

@MainActor
final class ToastPresenter {
    private static var toastWindow: ToastWindow?

    static func show(_ item: ToastItem, completion: @escaping () -> Void) {
        guard let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            completion()
            return
        }

        let window = ToastWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear

        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        vc.view.isUserInteractionEnabled = false
        window.rootViewController = vc
        window.isHidden = false

        toastWindow = window

        let toastView = item.view
        toastView.configure(with: item)
        vc.view.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])

        toastView.showAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + item.duration) {
                toastView.dismissAnimation {
                    window.isHidden = true
                    toastWindow = nil
                    completion()
                }
            }
        }
    }

    static func dismiss() {
        toastWindow?.isHidden = true
        toastWindow = nil
    }
}
