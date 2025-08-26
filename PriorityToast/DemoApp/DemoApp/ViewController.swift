//
//  ViewController.swift
//  DemoApp
//
//  Created by SONG on 8/26/25.
//

import UIKit
import PriorityToast

class ViewController: UIViewController {
    private let prioirtyToastManager = PriorityToastManager.shared
    
    private let showToastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Toast", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupButton()
    }
    
    private func setupButton() {
        view.addSubview(showToastButton)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            showToastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showToastButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showToastButton.heightAnchor.constraint(equalToConstant: 44),
            showToastButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        showToastButton.addTarget(self, action: #selector(showToastTapped), for: .touchUpInside)
    }
    
    @objc private func showToastTapped() {
        let toast = ToastItem(
            message: "토스토스토스토스토스트",
            priority: .highest
        )
        prioirtyToastManager.configure(policy: .discard)
        prioirtyToastManager.show(toast)
    }
}
