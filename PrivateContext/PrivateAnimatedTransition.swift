//
//  PrivateAnimatedTransition.swift
//  PrivateContext
//
//  Created by Neil Jain on 2/24/19.
//  Copyright © 2019 Neil Jain. All rights reserved.
//

import UIKit

class PrivateAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var childViewPadding: CGFloat = 0
    var duration: TimeInterval = 0.5
    var damping: CGFloat = 1
    var initialSpringDamping: CGFloat = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        let goingRight = transitionContext.initialFrame(for: toViewController!).origin.x < transitionContext.finalFrame(for: toViewController!).origin.x
        let travelDistance = transitionContext.containerView.bounds.width + childViewPadding
        let travel = CGAffineTransform(translationX: goingRight ? travelDistance : -travelDistance, y: 0)
        
        transitionContext.containerView.anchor(toViewController!.view)
        toViewController?.view.alpha = 0
        toViewController?.view.transform = travel.inverted()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: initialSpringDamping, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            fromViewController?.view.transform = travel
            //fromViewController?.view.alpha = 0
            toViewController?.view.transform = .identity
            toViewController?.view.alpha = 1
        }) { (finished) in
            fromViewController?.view.transform = .identity
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled))
        }
    }
    

}
