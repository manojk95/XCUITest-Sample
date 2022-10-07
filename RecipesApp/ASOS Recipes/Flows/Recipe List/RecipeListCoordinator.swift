//
//  RecipeListCoordinator.swift
//  ASOS Recipes
//

import UIKit

class RecipeListCoordinator: BaseCoordinator {
    private let router: Router
    private let dependencies: RecipeListViewModel.Dependencies
    
    private lazy var viewModel: RecipeListViewModelProtocol = {
        let viewModel = RecipeListViewModel (dependencies: self.dependencies)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    // MARK: Init
    init (router: Router, dependencies: RecipeListViewModel.Dependencies) {
        self.router = router
        self.dependencies = dependencies
    }
    
    // MARK: Coordinator
    override func start() {
        // Instantiate and show the recipe list.
        let recipeList = RecipeListViewController.instantiate (fromStoryboard: .recipeList)
        // Create the view model.
        recipeList.viewModel = self.viewModel
        self.router.push (viewController: recipeList, animated: false)
    }
}

extension RecipeListCoordinator: RecipeListViewModelCoordinatorDelegate {
    func showRecipe (_ recipe: Recipe) {
        // Note that this is not a different flow -- a single recipe is just pushed to the
        // stack and does nothing particular, as such a new coordinator is not required.
        // Instantiate the ViewModel for this recipe.
        let viewModel = RecipeViewModel (recipe: recipe, dependencies: self.dependencies)
        // Make ourselves the delegate of this view model.
        viewModel.coordinatorDelegate = self
        // Instantiate the recipe detail view.
        let controller = RecipeDetailTableViewController.instantiate (
            fromStoryboard: .recipeDetail)
        controller.viewModel = viewModel
        // Show the new controller.
        self.router.push (viewController: controller, animated: true)
    }
    
    func openFilterSelectionScreen (withCurrentFilter currentFilter: RecipeListFilter?) {
        // Instantiate the required coordinator and start it.
        let filterCoordinator = RecipeListFilterCoordinator (
            router: self.router, filter: currentFilter)
        self.addChild (filterCoordinator)
        // Once the children coordinator (which is a `ReturnsValueOnCompletion<T>`) finishes,
        // we can remove it from our children (preventing leaks) and pass the result to the
        // main, Recipe List view model.
        filterCoordinator.onComplete = { [weak self, weak filterCoordinator] result in
            self?.removeChild (filterCoordinator)
            if let newFilter = result {
                self?.viewModel.changeFilter (to: newFilter)
            }
        }
        filterCoordinator.start()
    }
}

extension RecipeListCoordinator: RecipeViewModelCoordinatorDelegate {
    func navigate (toRecipeURL url: URL) {
        UIApplication.shared.open (url, options: [:])
    }
}
