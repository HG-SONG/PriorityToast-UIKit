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
    private static var rootVC: UIViewController?
    private static var currentViews: [UUID: ToastViewProtocol] = [:]

    private static func setupIfNeeded() {
        guard toastWindow == nil,
              let scene = UIApplication.shared.connectedScenes
                  .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }

        let window = ToastWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear

        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        vc.view.isUserInteractionEnabled = false

        window.rootViewController = vc
        window.isHidden = false

        toastWindow = window
        rootVC = vc
    }

    static func showToast(_ item: ToastItem) async {
        setupIfNeeded()
        guard let vc = rootVC else { return }

        let toastView = item.view
        toastView.configure(with: item)

        currentViews[item.id] = toastView
        
        vc.view.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
        
        await toastView.showAnimation(duration: item.duration)
       
    }

    // 토스트 제거
    static func dismissToast(_ id: UUID) async {
        guard let toastView = currentViews[id] else { return }
        
        await toastView.dismissAnimation()
        cleanupView(id)
    }

    private static func cleanupView(_ id: UUID) {
        guard let toastView = currentViews[id] else { return }
        toastView.removeFromSuperview()
        currentViews[id] = nil
    }
}
