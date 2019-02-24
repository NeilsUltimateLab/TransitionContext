//
//  ViewController.swift
//  PrivateContext
//
//  Created by Neil Jain on 2/24/19.
//  Copyright © 2019 Neil Jain. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

protocol ContainmentProvider: class {
    var containerView: UIView! { get set }
    var visibleViewController: UIViewController? { get set }
    func addChild(_ viewController: UIViewController, to container: UIView)
    func removeChild(_ viewController: UIViewController?)
}

extension ContainmentProvider where Self: UIViewController {
    func addChild(_ viewController: UIViewController, to container: UIView) {
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        container.anchor(viewController.view)
        viewController.didMove(toParent: self)
        self.visibleViewController = viewController
    }
    
    func removeChild(_ viewController: UIViewController?) {
        viewController?.willMove(toParent: nil)
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParent()
        viewController?.didMove(toParent: nil)
    }
}

extension ViewController {
    enum State: Int {
        case first
        case second
        case third
        
        mutating func next() {
            switch self {
            case .first:
                self = .second
            case .second:
                self = .third
            case .third:
                self = .first
            }
        }
    }
}

class ViewController: UIViewController, ContainmentProvider {
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    var visibleViewController: UIViewController?
    
    var firstViewController: UIViewController?
    var secondViewController: UIViewController?
    var thirdViewController: UIViewController?
    var animator: PrivateAnimatedTransition?
    
    var state: State = .first {
        didSet {
            manage(state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = .first
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.state.next()
    }
    
    func manage(_ state: State) {
        switch state {
        case .first:
            self.transitionChild(toViewController: firstViewController ?? firstVC())
        case .second:
            self.transitionChild(toViewController: secondViewController ?? secondVC())
        case .third:
            self.transitionChild(toViewController: thirdViewController ?? thirdVC())
        }
    }
    
    func transitionChild(toViewController: UIViewController) {
        guard let fromViewController = self.visibleViewController else {
            self.addChild(toViewController, to: containerView)
            return
        }
        fromViewController.willMove(toParent: nil)
        toViewController.willMove(toParent: self)
        
        let animator = PrivateAnimatedTransition()
        
        let transitionContext = PrivateTransitionContext(fromViewController: fromViewController, toViewController: toViewController, direction: .left)
        transitionContext.isAnimated = true
        transitionContext.isInteractive = false
        transitionContext.onCompletion = { (completed) in
            fromViewController.view.removeFromSuperview()
            fromViewController.removeFromParent()
            toViewController.didMove(toParent: self)
            self.visibleViewController = toViewController
            self.nextButton.isUserInteractionEnabled = true
        }
        
        animator.animateTransition(using: transitionContext)
        self.nextButton.isUserInteractionEnabled = false
    }
    
    func firstVC() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.red
        firstViewController = vc
        return vc
    }
    
    func secondVC() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.green
        secondViewController = vc
        return vc
    }
    
    func thirdVC() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        thirdViewController = vc
        return vc
    }

}

