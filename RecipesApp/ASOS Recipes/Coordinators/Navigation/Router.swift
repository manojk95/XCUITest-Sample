//
//  Router.swift
//  ASOS Recipes
//

import UIKit

/// Handles navigation and is passed around to coordinators.
protocol Router {
    func push (viewController: UIViewController, animated: Bool)
    func present (viewController: UIViewController)
    func dismiss (animated: Bool)
}

/// Extension for `UINavigationController` to act as a router.
extension UINavigationController: Router {
    func push (viewController: UIViewController, animated: Bool) {
        self.pushViewController (viewController, animated: animated)
    }
    
    func present (viewController: UIViewController) {
        self.present (viewController, animated: true, completion: nil)
    }
    
    func dismiss (animated: Bool) {
        self.dismiss (animated: animated, completion: nil)
    }
}
