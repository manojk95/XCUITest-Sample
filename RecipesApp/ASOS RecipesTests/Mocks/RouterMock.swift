//
//  RouterMock.swift
//  ASOS RecipesTests
//

import UIKit
@testable import ASOS_Recipes

final class RouterMock: Router {
    var currentlyPresented: UIViewController? = nil
    var controllers = [UIViewController]()
    
    func push (viewController: UIViewController, animated: Bool) {
        self.controllers.append (viewController)
        self.currentlyPresented = viewController
    }
    
    func present (viewController: UIViewController) {
        self.controllers.append (viewController)
        self.currentlyPresented = viewController
    }
    
    func dismiss(animated: Bool) {
        self.controllers.removeLast()
        self.currentlyPresented = self.controllers.last
    }
}
