//
//  CircularProgressView.swift
//  PriorityToast
//
//  Created by SONG on 8/26/25.
//

import UIKit

public final class CircularProgressView: UIView {
    public var isAnimating: Bool = false
    private let progressLayer: CAShapeLayer
    private let progressBackgroundLayer: CAShapeLayer
    public var currentProgress: Float = 0
    private let contentInset: CGFloat = 4
    
    public init(progressColor: UIColor, backgroundColor: UIColor, lineWidth: CGFloat) {
        self.progressLayer = CAShapeLayer()
        self.progressBackgroundLayer = CAShapeLayer()
        super.init(frame: CGRect.zero)
        self.setupLayerAppearance(
            progressColor: progressColor,
            backgroundColor: backgroundColor,
            lineWidth: lineWidth
        )
        self.layer.addSublayer(self.progressBackgroundLayer)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawCircularPath(rect)
    }
    
    public func startAnimation(duration: TimeInterval, from: Float, to value: Float) {
        self.isAnimating = true
        self.layer.addSublayer(self.progressLayer)
        self.setProgress(duration: duration, from: from, to: value)
    }
    
    func setupProgressLayerStrokeColor(with color: UIColor) {
        self.progressLayer.strokeColor = color.cgColor
    }
    
    func setupProgressBackgroundLayerStrokeColor(with color: UIColor) {
        self.progressBackgroundLayer.strokeColor = color.cgColor
    }
    
    func resetProgress() {
        self.progressLayer.strokeEnd = 0
        self.isAnimating = false
    }
}

// MARK: - Setup animation

extension CircularProgressView {
    private func drawCircularPath(_ rect: CGRect) {
        let startAngle = -(Double.pi / 2)
        let endAngle = 3 * Double.pi / 2
        let arcCenter = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (rect.width / 2) - contentInset
        
        let circularPath = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        self.progressBackgroundLayer.path = circularPath.cgPath
        self.progressLayer.path = circularPath.cgPath
    }
    
    private func setProgress(duration: TimeInterval, from: Float, to value: Float) {
        self.currentProgress = value
        let animationKeyPath = "strokeEnd"
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = value
        animation.delegate = self
        self.progressLayer.strokeEnd = CGFloat(value)
        self.progressLayer.add(animation, forKey: animation.keyPath)
    }
}

extension CircularProgressView: @preconcurrency CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        self.isAnimating = false
    }
}

// MARK: - Setup appearance

extension CircularProgressView {
    private func setupLayerAppearance(
        progressColor: UIColor,
        backgroundColor: UIColor,
        lineWidth: CGFloat
    ) {
        self.setupCircularLayerFillColor()
        self.setupCircularLayerLineWidth(to: lineWidth)
        self.setupProgressLayerStrokeColor(with: progressColor)
        self.setupProgressBackgroundLayerColor(with: backgroundColor)
    }
    
    private func setupCircularLayerFillColor() {
        self.progressLayer.fillColor = nil
        self.progressBackgroundLayer.fillColor = nil
    }
    
    private func setupCircularLayerLineWidth(to lineWidth: CGFloat) {
        self.progressLayer.lineWidth = lineWidth
        self.progressBackgroundLayer.lineWidth = lineWidth
    }
    
    private func setupProgressBackgroundLayerColor(with color: UIColor) {
        self.progressBackgroundLayer.strokeColor = color.cgColor
    }
}
