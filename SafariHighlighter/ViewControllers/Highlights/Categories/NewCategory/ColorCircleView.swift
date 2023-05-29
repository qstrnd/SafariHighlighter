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
    
    func bounce() {
        let viewToBounce = self
        let originalFrame = viewToBounce.frame
        
        // Set up the animation parameters
        let bounceDuration = 0.2
        let bounceScale: CGFloat = 0.8
        
        // Perform the bounce animation
        UIView.animate(withDuration: bounceDuration, animations: {
            viewToBounce.transform = CGAffineTransform(scaleX: bounceScale, y: bounceScale)
        }, completion: { _ in
            UIView.animate(withDuration: bounceDuration, animations: {
                viewToBounce.transform = CGAffineTransform.identity
                viewToBounce.frame = originalFrame
            })
        })
    }
}
