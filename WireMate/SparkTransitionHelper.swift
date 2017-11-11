//
//  SparkTransitionHelper.swift
//  WireMate
//
//  Created by Hubert  on 11.11.2017.
//  Copyright © 2017 Hubert Zajączkowski. All rights reserved.
//

import UIKit

class FadeInOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 1.0
    var presenting: Bool = true
    
    var transformPresent: Bool = true
    var paralax2DPresent: Bool = true
    
    typealias completionHandler = (_ success: Bool) -> ()
    
    var completionHandlerBlock: completionHandler? = nil
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)) != nil else {
            print("Error during processing custom transition. FromVC corrupted.")
            return
        }
        guard (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)) != nil else {
            print("Error during processing custom transition. ToVC corrupted.")
            return
        }
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            print("Error during processing custom transition. FromView corrupted.")
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            print("Error during processing custom transition. ToView corrupted.")
            return
        }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        for view in toView.subviews {
            if self.transformPresent {
                if paralax2DPresent {
                    view.transform = CGAffineTransform(translationX: (toView.frame.width/toView.frame.height * (view.frame.origin.y + view.frame.height / 2)), y: 0.0)
                } else {
                    view.transform = CGAffineTransform(translationX: toView.frame.width, y: 0.0)
                }
            }
            view.alpha = 0.0
        }
        
        UIView.animate(withDuration: self.duration, animations: {
            for view in fromView.subviews {
                view.alpha = 0.0
            }
        }, completion: {(_ :Bool) -> Void in
            UIView.animate(withDuration: self.duration, animations: {
                for view in toView.subviews {
                    if self.transformPresent {
                        view.transform = CGAffineTransform.identity
                    }
                    view.alpha = 1.0
                }
            }, completion: self.completionHandlerBlock)
            let success = !transitionContext.transitionWasCancelled
            if (self.presenting && !success) || (!self.presenting && success) {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }
}

