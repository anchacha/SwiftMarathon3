//
//  GradientView.swift
//  SwiftMarathon3
//
//  Created by Anton Charny on 07/03/2023.
//

import UIKit

class GradientView: UIView {
    
    enum GradientType {
        case linear
        case radial
    }
    
    public var gradientColors: [UIColor]
    public var sizeMultiplier: CGFloat
    
    private var gradientType: GradientType
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setGradient(colors: self.gradientColors)
    }
    
    init(colors: [UIColor], cornerRadius: CGFloat, multiplier: CGFloat, gradientType: GradientType = .linear) {
        self.gradientColors = colors
        self.sizeMultiplier = multiplier
        self.gradientType = gradientType
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = cornerRadius
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    private func setGradient(colors: [UIColor]) {
        guard !colors.isEmpty, let context = UIGraphicsGetCurrentContext() else { return }
        let locations = self.setColoursLocations(colorsCount: colors.count)
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors.map { $0.cgColor } as CFArray,
                                        locations: locations) else { return }
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                cornerRadius: self.layer.cornerRadius)
        context.saveGState()
        path.addClip()
        
        switch self.gradientType {
        case .linear:
            let startPoint = colors.count == 2 ? CGPoint(x: -bounds.width / 3, y: -bounds.height / 3) : .zero
            let endPoint = CGPoint(x: bounds.width, y: bounds.height)
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        case .radial:
            context.drawRadialGradient(
                gradient,
                startCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                startRadius: bounds.width / 4,
                endCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                endRadius: bounds.width / 2 ,
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
        
        context.restoreGState()
    }
    
    private func setColoursLocations(colorsCount: Int) -> [CGFloat] {
        var locations = [CGFloat]()
        for colorIndex in 0..<colorsCount {
            if colorIndex == colorsCount - 1 {
                locations.append(1)
                break
            }
            locations.append(CGFloat(colorIndex) * 0.25)
        }
        return locations
    }
}
