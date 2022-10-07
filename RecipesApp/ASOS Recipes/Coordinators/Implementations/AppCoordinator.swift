//
//  AppCoordinator.swift
//  ASOS Recipes
//

import UIKit

class AppCoordinator: BaseCoordinator {
    /// The main router.
    let router: Router
    
    /// The main dependencies, given to the coordinators.
    let appDependencies: AppDependencies
    
    // MARK: Init
    init (router: Router, dependencies: AppDependencies) {
        self.router = router
        self.appDependencies = dependencies
    }
    
    // MARK: Coordinator
    override func start() {
        self.showRecipeList()
    }
    
    // MARK: Private methods
    private func showRecipeList() {
        let recipeListCoordinator = RecipeListCoordinator (
            router: self.router,
            dependencies: self.appDependencies
        )
        self.addChild (recipeListCoordinator)
        recipeListCoordinator.start()
    }
}
