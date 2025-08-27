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

    // 토스트 표시 (애니메이션만, 시간 제어는 Manager에서)
    static func showToast(_ item: ToastItem) async {
        setupIfNeeded()
        guard let vc = rootVC else { return }

        let toastView = item.view
        toastView.configure(with: item)
        
        // 뷰 저장
        currentViews[item.id] = toastView
        
        vc.view.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])

        do {
            // 등장 애니메이션만 실행
            try await toastView.showAnimation(duration: item.duration) // 애니메이션 시간은 별도로 관리
        } catch {
            // 애니메이션 실패
        }
    }

    // 토스트 제거
    static func dismissToast(_ id: UUID) async {
        guard let toastView = currentViews[id] else { return }
        
        do {
            try await toastView.dismissAnimation()
        } catch {
            // 애니메이션 실패
        }
        
        cleanupView(id)
    }

    private static func cleanupView(_ id: UUID) {
        guard let toastView = currentViews[id] else { return }
        toastView.removeFromSuperview()
        currentViews[id] = nil
    }
}
