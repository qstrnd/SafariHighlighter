//
//  NewCategoryColorPickerView.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 13.05.2023.
//

import UIKit

protocol NewCategoryColorPickerViewDelegate: AnyObject {
    func categoryColorPicker(_ colorPicker: NewCategoryColorPickerView, didSelectColor color: UIColor)
}


final class NewCategoryColorPickerView: UIView {
    
    // MARK: - Internal
    
    weak var delegate: NewCategoryColorPickerViewDelegate?
    
    var circleViews: [ColorCircleView] = []
    
    var numberOfCircles: Int = 0 {
        didSet {
            updateCircleViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds.size.width != previousLayoutWidth else { return }
        previousLayoutWidth = bounds.size.width
        
        updateCircleViews()
    }
    
    // MARK: - Private
    
    private var previousLayoutWidth: CGFloat = .zero
    
    private func updateCircleViews() {
        circleViews.forEach { $0.removeFromSuperview() }
        circleViews = []
        
        guard bounds.size != .zero else { return }
        let frames = generateChessboardFrames(numberOfItems: numberOfCircles, bounds: bounds)
        
        frames.forEach { circleFrame in
            let circleView = ColorCircleView(frame: circleFrame)
            circleView.color = generateRandomColor()
            circleView.beginShivering()
            
            circleView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:)))
            circleView.addGestureRecognizer(tapGesture)
            
            addSubview(circleView)
            circleViews.append(circleView)
        }
        
    }
    
    private func generateRandomColor() -> UIColor {
        // Generate a random hue value between 0 and 1
        let hue = CGFloat.random(in: 0...1)
        
        // Calculate the other two hues for a triadic color harmony
        let hue2 = fmod(hue + 0.33, 1.0)
        let hue3 = fmod(hue + 0.67, 1.0)
        
        // Create UIColors from the three hues
        let color1 = UIColor(hue: hue, saturation: 0.7, brightness: 0.9, alpha: 1.0)
        let color2 = UIColor(hue: hue2, saturation: 0.7, brightness: 0.9, alpha: 1.0)
        let color3 = UIColor(hue: hue3, saturation: 0.7, brightness: 0.9, alpha: 1.0)
        
        // Combine the three colors into a random color scheme
        let colors = [color1, color2, color3]
        let randomIndex = Int.random(in: 0..<3)
        let randomColor = colors[randomIndex]
        
        return randomColor
    }
    
    private func generateChessboardFrames(numberOfItems: Int, bounds: CGRect) -> [CGRect] {
        var frames: [CGRect] = []
        let columns: Int = Int(sqrt(Double(numberOfItems)))
        let cellWidth: CGFloat = bounds.width / CGFloat(columns)
        let cellHeight = cellWidth
        let minCellSizeRatio: CGFloat = 0.7
        let maxCellSizeRatio: CGFloat = 1.1
        
        for i in 0..<numberOfItems {
            let row: Int = i / columns
            let column: Int = i % columns
            let cellBounds = CGRect(x: bounds.origin.x + CGFloat(column) * cellWidth,
                                    y: bounds.origin.y + CGFloat(row) * cellHeight,
                                    width: cellWidth,
                                    height: cellHeight)
            
            // add some randomness to the cell size
            let randomSizeCoefficient = CGFloat.random(in: minCellSizeRatio...maxCellSizeRatio)
            let randomCellWidth = cellWidth * randomSizeCoefficient
            let randomCellHeight = cellHeight * randomSizeCoefficient
            let randomCellBounds = CGRect(x: cellBounds.midX - randomCellWidth / 2,
                                          y: cellBounds.midY - randomCellHeight / 2,
                                          width: randomCellWidth,
                                          height: randomCellHeight)
            
            frames.append(randomCellBounds)
        }
        
        return frames
    }
    
    // MARK: Actions
    
    @objc
    private func circleTapped(_ sender: UITapGestureRecognizer) {
        guard let circleView = sender.view as? ColorCircleView else { return }
        delegate?.categoryColorPicker(self, didSelectColor: circleView.color)
    }
}
