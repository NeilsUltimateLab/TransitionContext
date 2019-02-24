//
//  PrivateTransitionContext.swift
//  PrivateContext
//
//  Created by Neil Jain on 2/24/19.
//  Copyright © 2019 Neil Jain. All rights reserved.
//

import UIKit

class PrivateTransitionContext: NSObject, UIViewControllerContextTransitioning {
    enum Direction {
        case left
        case right
    }
    var containerView: UIView
    
    var isAnimated: Bool = true
    var isInteractive: Bool = false
    var transitionWasCancelled: Bool = false
    
    var presentationStyle: UIModalPresentationStyle = .custom
    var targetTransform: CGAffineTransform = .identity
    var viewControllers: [UITransitionContextViewControllerKey: UIViewController] = [:]
    var onCompletion: ((_ didComplete: Bool) -> Void)?
    
    private var direction: Direction = .left
    private var views: [UITransitionContextViewKey: UIView] = [:]
    private var disappearingFromRect: CGRect = .zero
    private var appearingFromRect: CGRect = .zero
    private var disappearingToRect: CGRect = .zero
    private var appearingToRect: CGRect = .zero
    
    init(fromViewController: UIViewController, toViewController: UIViewController, direction: Direction) {
        assert(fromViewController.view.superview != nil, "fromViewController view must reside in containerView upon initialising the transition context.")
        self.containerView = fromViewController.view.superview!
        viewControllers[.from] = fromViewController
        viewControllers[.to] = toViewController
        views[.from] = fromViewController.view
        views[.to] = toViewController.view
        self.direction = direction
        let travelDistance = direction == .right ? -containerView.bounds.width : containerView.bounds.width
        self.disappearingFromRect = containerView.bounds
        self.appearingFromRect = containerView.bounds
        self.disappearingToRect = containerView.bounds.offsetBy(dx: travelDistance, dy: 0)
        self.appearingToRect = containerView.bounds.offsetBy(dx: -travelDistance, dy: 0)
        super.init()
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        return
    }
    
    func finishInteractiveTransition() {
        return
    }
    
    func cancelInteractiveTransition() {
        return
    }
    
    func pauseInteractiveTransition() {
        return
    }
    
    func completeTransition(_ didComplete: Bool) {
        self.onCompletion?(didComplete)
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return views[key]
    }
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        if vc == viewController(forKey: .from) {
            return disappearingFromRect
        } else {
            return appearingFromRect
        }
    }
    
    func finalFrame(for vc: UIViewController) -> CGRect {
        if vc == viewController(forKey: .from) {
            return disappearingToRect
        } else {
            return appearingToRect
        }
    }
    
}
