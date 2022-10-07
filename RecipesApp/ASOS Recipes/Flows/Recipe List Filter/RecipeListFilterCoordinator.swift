//
//  RecipeListFIlterCoordinator.swift
//  ASOS Recipes
//

import UIKit

class RecipeListFilterCoordinator: BaseCoordinator, ReturnsValueOnCompletion {
    // MARK: ReturnsValueOnCompletion
    typealias ValueType = RecipeListFilter?
    var onComplete: ((RecipeListFilter?) -> ())?
    
    // MARK: Instance Properties
    private let router: Router
    private let filter: RecipeListFilter?
    
    private lazy var viewModel: RecipeListFilterViewModel = {
        let viewModel = RecipeListFilterViewModel (currentFilter: self.filter)
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    // MARK: Init
    init (router: Router, filter: RecipeListFilter?) {
        self.router = router
        self.filter = filter
    }
    
    // MARK: Coordinator
    override func start() {
        // Create the filter selection screen.
        let filterSelection = RecipeFilterSelectionTableViewController.instantiate (
            fromStoryboard: .recipeFilters)
        // Instantiate its view model and associated properties.
        filterSelection.viewModel = self.viewModel
        // Wrap the controller in a NavigationController to retain the bars.
        self.router.present (viewController:
            UINavigationController (rootViewController: filterSelection))
    }
}

// MARK: RecipeListFilterViewModelCoordinatorDelegate
extension RecipeListFilterCoordinator: RecipeListFilterViewModelCoordinatorDelegate {
    func filterViewFinished (result: RecipeListFilter?) {
        self.onComplete?(result)
        self.router.dismiss (animated: true)
    }
}
