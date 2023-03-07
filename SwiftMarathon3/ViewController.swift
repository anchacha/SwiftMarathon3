//
//  ViewController.swift
//  SwiftMarathon3
//
//  Created by Anton Charny on 07/03/2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var slider = UISlider()
    
    private lazy var squareView = GradientView(colors: [.systemBlue, .magenta, .green, .purple],
                                               cornerRadius: 8, multiplier: 1.5)
    private lazy var square2 = GradientView(colors: [.white, .red, .white],
                                            cornerRadius: 8, multiplier: 3, gradientType: .radial)
    
    private lazy var squaresArray: [GradientView] = [self.squareView, self.square2]
    
    private var leadingConstraintsArray: [NSLayoutConstraint] = []
    private var traillingConstraintsArray: [NSLayoutConstraint] = []
    
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var cubeSide: CGFloat = 64
    let multipier: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16,
                                                                     bottom: 16, trailing: 16)
        self.setupAnimation()
        self.setupViews()
        self.setupSlider()
        
        self.view.addConstraints([
            .init(item: self.squareView, attribute: .top, relatedBy: .equal,
                  toItem: self.view, attribute: .topMargin, multiplier: 1, constant: self.cubeSide),
            .init(item: self.slider, attribute: .top, relatedBy: .equal,
                  toItem: self.squareView, attribute: .bottom, multiplier: 1, constant: self.cubeSide),
            .init(item: self.square2, attribute: .top, relatedBy: .equal,
                  toItem: self.slider, attribute: .bottom, multiplier: 1, constant: self.cubeSide * 1.5)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.addShadow()
    }
    
    @objc func sliderValueChanged() {
        self.animator.fractionComplete = CGFloat(slider.value)
    }
    
    @objc func releaseSlider() {
        let displayLink = CADisplayLink(target: self, selector: #selector(updateSliderValue))
        displayLink.add(to: .current, forMode: .common)
        self.animator.startAnimation()
    }
    
    @objc func updateSliderValue() {
        if self.animator.isRunning {
            self.slider.value = Float(self.animator.fractionComplete)
        }
    }
    
    func setupAnimation() {
        self.animator.pausesOnCompletion = true
        
        self.animator.addAnimations {
            self.leadingConstraintsArray.forEach { $0.isActive = false }
            self.traillingConstraintsArray.forEach { $0.isActive = true }
            
            self.squaresArray.forEach { $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
                .scaledBy(x: $0.sizeMultiplier, y: $0.sizeMultiplier) }
            self.view.layoutIfNeeded()
        }
    }
    
    func setupSlider() {
        self.view.addSubview(self.slider)
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        
        self.slider.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        self.slider.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        self.slider.value = self.slider.minimumValue
        self.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(releaseSlider), for: .touchUpInside)
    }
    
    func setupViews() {
        self.squaresArray.forEach { view in
            self.view.addSubview(view)
            self.addCommonConstraints(squareView: view)
        }
        
        self.leadingConstraintsArray.forEach({ $0.isActive = true })
        self.traillingConstraintsArray.forEach({ $0.isActive = false })
    }
    
    private func addCommonConstraints(squareView: GradientView) {
        squareView.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingConstraintsArray.append(.init(item: squareView,
                                                  attribute: .leading,
                                                  relatedBy: .equal,
                                                  toItem: self.view,
                                                  attribute: .leadingMargin, multiplier: 1, constant: 0))
        
        self.traillingConstraintsArray.append(.init(item: squareView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .trailingMargin,
                                                    multiplier: 1, constant: self.distanseToNewCubeCenter(multiplier: squareView.sizeMultiplier)))
        
        squareView.widthAnchor.constraint(equalToConstant: self.cubeSide).isActive = true
        squareView.heightAnchor.constraint(equalToConstant: self.cubeSide).isActive = true
    }
    
    private func distanseToNewCubeCenter(multiplier: CGFloat) -> CGFloat {
        let endCubeSidePercentageGrow = 1 - ((self.cubeSide * multiplier) / self.cubeSide)
        let halfSideGrow = endCubeSidePercentageGrow / 2
        let dist = (self.cubeSide * halfSideGrow)
        
        return dist
    }
    
    private func addShadow() {
        self.squaresArray.forEach {
            let path = UIBezierPath(roundedRect: $0.bounds,
                                    cornerRadius: $0.layer.cornerRadius)
            
            $0.layer.shadowPath = path.cgPath
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
            $0.layer.shadowOpacity = 1
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.masksToBounds = false
        }
    }
}
