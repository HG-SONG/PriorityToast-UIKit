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
    
    private let showHighToastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show High Toast", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let showLowToastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Low Toast", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let showHighestCustomToastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Highest Custom Toast", for: .normal)
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
        view.addSubview(showHighToastButton)
        view.addSubview(showLowToastButton)
        view.addSubview(showHighestCustomToastButton)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            showHighToastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHighToastButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showHighToastButton.heightAnchor.constraint(equalToConstant: 44),
            showHighToastButton.widthAnchor.constraint(equalToConstant: 160),
            
            showLowToastButton.topAnchor.constraint(equalTo: showHighToastButton.bottomAnchor,constant: 20),
            showLowToastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showLowToastButton.heightAnchor.constraint(equalToConstant: 44),
            showLowToastButton.widthAnchor.constraint(equalToConstant: 160),
            
            showHighestCustomToastButton.topAnchor.constraint(equalTo: showLowToastButton.bottomAnchor,constant: 20),
            showHighestCustomToastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showHighestCustomToastButton.heightAnchor.constraint(equalToConstant: 44),
            showHighestCustomToastButton.widthAnchor.constraint(equalToConstant: 250)
            
            
        ])
        
        showHighToastButton.addTarget(self, action: #selector(showHighToastTapped), for: .touchUpInside)
        showLowToastButton.addTarget(self, action: #selector(showLowToastTapped), for: .touchUpInside)
        showHighestCustomToastButton.addTarget(self, action: #selector(showHighesCustomToastTapped), for: .touchUpInside)
    }
    
    @objc private func showHighToastTapped() {
        let toast = ToastItem(
            message: "Show High Toast",
            priority: .high
        )
        prioirtyToastManager.configure(policy: .discard)
        prioirtyToastManager.show(toast)
    }
    
    @objc private func showLowToastTapped() {
        let toast = ToastItem(
            message: "Show Low Toast",
            priority: .low
        )
        prioirtyToastManager.configure(policy: .discard)
        prioirtyToastManager.show(toast)
    }
    
    @objc private func showHighesCustomToastTapped() {
        let style = DefaultToastStyle(backgroundColor: .white, borderColor: .red, accessoryColor: .red, textColor: .red)
        let toastView = DefaultToastView(style: style)
        toastView.setAccessoryView(UIImageView(image: UIImage.remove))
        
        let toast = ToastItem(
            message: "Show The Highest Custom Toast",
            priority: .highest,
            view: toastView
        )
        
        prioirtyToastManager.configure(policy: .discard)
        prioirtyToastManager.show(toast)
    }
}
