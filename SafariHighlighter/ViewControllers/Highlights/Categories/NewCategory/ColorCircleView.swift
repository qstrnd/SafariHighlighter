//
//  ColorCircleView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit

final class ColorCircleView: UIView {
    var color: UIColor = .black {
        didSet {
            backgroundColor = color
        }
    }
    
    private var animator: UIDynamicAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
    
    func beginShivering() {
        let maxPossibleOffset: CGFloat = 5
        let duration: TimeInterval = Double.random(in: 1 ... 10)
        
        let animation = CABasicAnimation(keyPath: "position")
        let startPosition = CGPoint(x: frame.midX, y: frame.midY)
        let randomXOffset = CGFloat.random(in: -maxPossibleOffset ... maxPossibleOffset)
        let randomYOffset = CGFloat.random(in: -maxPossibleOffset ... maxPossibleOffset)
        let endPosition = CGPoint(x: startPosition.x + randomXOffset, y: startPosition.y + randomYOffset)
        
        animation.fromValue = NSValue(cgPoint: startPosition)
        animation.toValue = NSValue(cgPoint: endPosition)
        animation.duration = duration
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(animation, forKey: "slowMovingAnimation")
    }
}