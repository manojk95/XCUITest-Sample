//
//  Storyboard.swift
//  ASOS Recipes
//

import UIKit

/// Represents one of the local storyboards.
enum Storyboard: String {
    case recipeList = "RecipeList"
    case recipeFilters = "RecipeFilters"
    case recipeDetail = "RecipeDetail"
}

extension UIViewController {
    /// Given an `UIStoryboard` reference, instantiates the initial controller of that storyboard
    /// to the expected type.
    /// Note that the initial controller must exist and MUST be of the given controller type.
    static func instantiateInitialController<T: UIViewController>(in storyboard: UIStoryboard) -> T {
        return storyboard.instantiateInitialViewController()! as! T
    }
    
    static func instantiate (fromStoryboard storyboard: Storyboard) -> Self {
        let storyboard = UIStoryboard (name: storyboard.rawValue, bundle: nil)
        return instantiateInitialController (in: storyboard)
    }
}
