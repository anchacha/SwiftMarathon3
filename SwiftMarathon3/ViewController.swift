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
                                               cornerRadius: 8)
    
    var leadingConstraint: NSLayoutConstraint?
    var traiilingConstant: NSLayoutConstraint?
    
    var animator: UIViewPropertyAnimator!
    
    var cubeSide: CGFloat = 64
    let multipier: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16,
                                                                     bottom: 16, trailing: 16)
        self.setupAnimation()
        self.setupView()
        self.setupSlider()
       
        
        self.view.addConstraint(.init(
            item: self.slider, attribute: .top, relatedBy: .equal,
            toItem: self.squareView, attribute: .bottom, multiplier: 1, constant: self.cubeSide))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.addShadow()
    }
    
    @objc func sliderValueChanged() {
        animator?.fractionComplete = CGFloat(slider.value)
    }
    
    @objc func releaseSlider() {
        let displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink.add(to: .current, forMode: .common)
        animator?.startAnimation()
    }
    
    @objc func updateAnimation() {
        if(animator.isRunning) {
            slider.value = Float(animator.fractionComplete)
        }
    }
    
    func setupAnimation() {
        self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        animator?.pausesOnCompletion = true
        
        animator?.addAnimations {
            self.leadingConstraint?.isActive = false
            self.traiilingConstant?.isActive = true
            
            self.squareView.transform = CGAffineTransform(rotationAngle: .pi / 2)
                .scaledBy(x: self.multipier, y: self.multipier)
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
        slider.addTarget(self, action: #selector(releaseSlider), for: .touchUpInside)
    }
    
    func setupView() {
        self.view.addSubview(self.squareView)
        self.squareView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.squareView.backgroundColor = .clear
        
        let margins = self.view.layoutMarginsGuide
        self.leadingConstraint = .init(item: self.squareView,
                                       attribute: .leading,
                                       relatedBy: .equal,
                                       toItem: self.view,
                                       attribute: .leadingMargin, multiplier: 1, constant: 0)
        self.leadingConstraint?.isActive = true
        
        self.traiilingConstant = .init(item: self.squareView,
                                       attribute: .trailing,
                                       relatedBy: .equal,
                                       toItem: self.view,
                                       attribute: .trailingMargin,
                                       multiplier: 1, constant: self.distanseToNewCubeCenter())
        self.traiilingConstant?.isActive = false
        
        self.squareView.widthAnchor.constraint(equalToConstant: self.cubeSide).isActive = true
        self.squareView.heightAnchor.constraint(equalToConstant: self.cubeSide).isActive = true
        self.squareView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 64).isActive = true
    }
    
    private func distanseToNewCubeCenter() -> CGFloat {
        let endCubeSidePercentageGrow = 1 - ((self.cubeSide * self.multipier) / self.cubeSide)
        let halfSideGrow = endCubeSidePercentageGrow / 2
        let dist = (self.cubeSide * halfSideGrow)
        
        return dist
    }
    
    private func addShadow() {
        let path = UIBezierPath(roundedRect: self.squareView.bounds,
                                cornerRadius: self.squareView.layer.cornerRadius)
        
        self.squareView.layer.shadowPath = path.cgPath
        self.squareView.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.squareView.layer.shadowOpacity = 1
        self.squareView.layer.shadowRadius = 3
        self.squareView.layer.shadowColor = UIColor.gray.cgColor
        self.squareView.layer.masksToBounds = false
    }
}
