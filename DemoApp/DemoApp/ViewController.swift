//
//  ViewController.swift
//  DemoApp
//
//  Created by SONG on 8/26/25.
//

import UIKit
import PriorityToast

class ViewController: UIViewController {
    private let priorityToastManager = PriorityToastManager.shared
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🍞 Priority Toast Demo"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let policySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Discard", "Requeue"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let clearAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗑️ Clear All Toasts", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Demo Configurations
    private struct ToastDemo {
        let title: String
        let priority: ToastPriority
        let message: String
        let backgroundColor: UIColor
        let textColor: UIColor
        let borderColor: UIColor?
        let accessoryImage: UIImage?
        let accessoryColor: UIColor?
    }
    
    private let toastDemos: [ToastDemo] = [
        // Highest Priority - Custom Style
        ToastDemo(
            title: "🚨 Critical Error (Highest)",
            priority: .highest,
            message: "Critical system error detected!",
            backgroundColor: .systemRed,
            textColor: .white,
            borderColor: .darkGray,
            accessoryImage: UIImage(systemName: "exclamationmark.triangle.fill"),
            accessoryColor: .white
        ),
        ToastDemo(
            title: "💥 Emergency Alert (Highest)",
            priority: .highest,
            message: "Emergency maintenance required",
            backgroundColor: UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0),
            textColor: .white,
            borderColor: UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0),
            accessoryImage: UIImage(systemName: "bell.fill"),
            accessoryColor: .white
        ),
        
        // High Priority - Custom Style
        ToastDemo(
            title: "⚠️ Warning Message (High)",
            priority: .high,
            message: "Something needs your attention",
            backgroundColor: .systemOrange,
            textColor: .white,
            borderColor: UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0),
            accessoryImage: UIImage(systemName: "exclamationmark.circle.fill"),
            accessoryColor: .white
        ),
        ToastDemo(
            title: "🔔 Important Update (High)",
            priority: .high,
            message: "New version available for download",
            backgroundColor: UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0),
            textColor: .white,
            borderColor: UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0),
            accessoryImage: UIImage(systemName: "arrow.down.circle.fill"),
            accessoryColor: .white
        ),
        
        // Medium Priority - Custom Style
        ToastDemo(
            title: "📋 Task Completed (Medium)",
            priority: .medium,
            message: "Your task has been completed successfully",
            backgroundColor: .systemBlue,
            textColor: .white,
            borderColor: UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0),
            accessoryImage: UIImage(systemName: "checkmark.circle.fill"),
            accessoryColor: .white
        ),
        ToastDemo(
            title: "💼 Work Progress (Medium)",
            priority: .medium,
            message: "Project milestone reached (50%)",
            backgroundColor: UIColor(red: 0.2, green: 0.7, blue: 0.9, alpha: 1.0),
            textColor: .white,
            borderColor: UIColor(red: 0.1, green: 0.5, blue: 0.7, alpha: 1.0),
            accessoryImage: UIImage(systemName: "progress.indicator"),
            accessoryColor: .white
        ),
        
        // Low Priority - Custom Style
        ToastDemo(
            title: "✅ Success (Low)",
            priority: .low,
            message: "Operation completed successfully",
            backgroundColor: .systemGreen,
            textColor: .white,
            borderColor: UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0),
            accessoryImage: UIImage(systemName: "checkmark.seal.fill"),
            accessoryColor: .white
        ),
        ToastDemo(
            title: "💬 Chat Message (Low)",
            priority: .low,
            message: "You have a new message from John",
            backgroundColor: UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0),
            textColor: .white,
            borderColor: UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0),
            accessoryImage: UIImage(systemName: "message.fill"),
            accessoryColor: .white
        ),
        
        // Lowest Priority - Custom Style
        ToastDemo(
            title: "📈 Analytics Update (Lowest)",
            priority: .lowest,
            message: "Weekly report is now available",
            backgroundColor: .systemPurple,
            textColor: .white,
            borderColor: UIColor(red: 0.6, green: 0.3, blue: 0.9, alpha: 1.0),
            accessoryImage: UIImage(systemName: "chart.bar.fill"),
            accessoryColor: .white
        ),
        ToastDemo(
            title: "🎉 Fun Fact (Lowest)",
            priority: .lowest,
            message: "Did you know? This is your 42nd toast!",
            backgroundColor: UIColor(red: 0.9, green: 0.6, blue: 1.0, alpha: 1.0),
            textColor: .darkText,
            borderColor: UIColor(red: 0.7, green: 0.4, blue: 0.8, alpha: 1.0),
            accessoryImage: UIImage(systemName: "lightbulb.fill"),
            accessoryColor: .darkGray
        )
    ]
    
    // Basic Toast Demos (Default style, no custom styling)
    private let basicToastDemos: [ToastDemo] = [
        ToastDemo(
            title: "🔹 Circular High (High)",
            priority: .high,
            message: "Circular high priority with accessory",
            backgroundColor: .clear,
            textColor: .label,
            borderColor: nil,
            accessoryImage: nil, // 기본 Circular Progress View 이용
            accessoryColor: nil // 기본 색상 사용
        ),
        ToastDemo(
            title: "🔸 Circular Medium (Medium)",
            priority: .medium,
            message: "Circular medium priority with accessory",
            backgroundColor: .clear,
            textColor: .label,
            borderColor: nil,
            accessoryImage: nil, // 기본 Circular Progress View 이용
            accessoryColor: nil // 기본 색상 사용
        ),
        ToastDemo(
            title: "🔺 Circular Low (Low)",
            priority: .low,
            message: "Default low priority with accessory",
            backgroundColor: .clear,
            textColor: .label,
            borderColor: nil,
            accessoryImage: nil, // 기본 Circular Progress View 이용
            accessoryColor: nil // 기본 색상 사용
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(policySegmentedControl)
        contentView.addSubview(clearAllButton)
        contentView.addSubview(stackView)
        
        // Add regular toast demo buttons
        for demo in toastDemos {
            let button = createDemoButton(title: demo.title, backgroundColor: demo.backgroundColor.withAlphaComponent(0.8))
            stackView.addArrangedSubview(button)
        }
        
        // Add separator
        let separator = createSeparator()
        stackView.addArrangedSubview(separator)
        
        // Add section title for basic toasts
        let basicSectionTitle = UILabel()
        basicSectionTitle.text = "Basic Toasts (Default Style)"
        basicSectionTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        basicSectionTitle.textColor = .secondaryLabel
        basicSectionTitle.textAlignment = .center
        stackView.addArrangedSubview(basicSectionTitle)
        
        // Add basic toast demo buttons
        for demo in basicToastDemos {
            let button = createDemoButton(title: demo.title, backgroundColor: UIColor.systemGray5)
            button.setTitleColor(.label, for: .normal)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            policySegmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            policySegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            policySegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            policySegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            clearAllButton.topAnchor.constraint(equalTo: policySegmentedControl.bottomAnchor, constant: 15),
            clearAllButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            clearAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            clearAllButton.heightAnchor.constraint(equalToConstant: 44),
            
            stackView.topAnchor.constraint(equalTo: clearAllButton.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        policySegmentedControl.addTarget(self, action: #selector(policyChanged), for: .valueChanged)
        clearAllButton.addTarget(self, action: #selector(clearAllToasts), for: .touchUpInside)
        
        // Add actions for regular demo buttons
        for (index, demo) in toastDemos.enumerated() {
            if let button = stackView.arrangedSubviews[index] as? UIButton {
                button.addAction(UIAction { [weak self] _ in
                    self?.showToastDemo(demo)
                }, for: .touchUpInside)
            }
        }
        
        let basicButtonStartIndex = toastDemos.count + 2
        for (index, demo) in basicToastDemos.enumerated() {
            let buttonIndex = basicButtonStartIndex + index
            if buttonIndex < stackView.arrangedSubviews.count,
               let button = stackView.arrangedSubviews[buttonIndex] as? UIButton {
                button.addAction(UIAction { [weak self] _ in
                    self?.showBasicToastDemo(demo)
                }, for: .touchUpInside)
            }
        }
    }
    
    @objc private func policyChanged() {
        let policy: ToastPolicy = policySegmentedControl.selectedSegmentIndex == 0 ? .discard : .requeue
        priorityToastManager.configure(policy: policy)
        
        // Show feedback
        let feedbackToast = ToastItem(
            message: "Policy changed to \(policy == .discard ? "Discard" : "Requeue")",
            priority: .medium
        )
        Task {
            await priorityToastManager.show(feedbackToast)
        }
    }
    
    // MARK: - Helper Methods
    private func createDemoButton(title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
    
    @objc private func clearAllToasts() {
        Task {
            await priorityToastManager.clearAll()
        }
    }
    
    // MARK: - Usages
    private func showToastDemo(_ demo: ToastDemo) {
        let style = DefaultToastStyle(
            backgroundColor: demo.backgroundColor,
            borderColor: demo.borderColor,
            accessoryColor: demo.accessoryColor ?? .black,
            textColor: demo.textColor
        )
        let toastView = DefaultToastView(style: style)
        
        if let accessoryImage = demo.accessoryImage {
            let accessoryImageView = UIImageView(image: accessoryImage)
            toastView.setAccessoryView(accessoryImageView)
        }
        
        let toast = ToastItem(
            message: demo.message,
            priority: demo.priority,
            view: toastView
        )
        
        Task {
            await priorityToastManager.show(toast)
        }
    }
    
    private func showBasicToastDemo(_ demo: ToastDemo) {
        let toast = ToastItem(
            message: demo.message,
            priority: demo.priority
        )
        
        // - MARK: ↓ No accessoryView
        // toast.view.setAccessoryView(nil)
        
        Task {
            await priorityToastManager.show(toast)
        }
    }
}
