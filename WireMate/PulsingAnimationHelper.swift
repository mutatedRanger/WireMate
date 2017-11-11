//
//  PulsingAnimationHelper.swift
//  WireMate
//
//  Created by Hubert  on 11.11.2017.
//  Copyright © 2017 Hubert Zajączkowski. All rights reserved.
//

import UIKit

public class PulsingAnimation: CALayer {
    
    var animationGroup = CAAnimationGroup()
    
    public var initialPulseScale: Float
    public var nextPulseAfter:    TimeInterval
    public var animationDuration: TimeInterval
    public var radius:            CGFloat
    public var numberOfPulses:    Float
    
    public override init() {
        self.initialPulseScale = 0.0
        self.nextPulseAfter = 0.0
        self.animationDuration = 1.0
        self.radius = 100.0
        self.numberOfPulses = Float.infinity
        
        super.init()
        
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.position = CGPoint.zero
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = self.radius
        
        self.setupAnimationGroup()
        
        self.addAnimationToTree()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAnimationToTree() {
        self.add(self.animationGroup, forKey: "pulse")
    }
    
    func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        self.animationGroup.timingFunction = defaultCurve
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
}
