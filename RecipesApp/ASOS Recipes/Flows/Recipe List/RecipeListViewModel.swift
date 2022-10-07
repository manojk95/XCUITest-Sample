//
//  RecipeListViewModel.swift
//  ASOS Recipes
//

import Foundation

protocol RecipeListViewModelProtocol {
    /// This view model's view delegate.
    var delegate: RecipeListViewModelDelegate? { get set }
    
    // MARK: Data source
    /// Provides the number of recipes.
    var numberOfItems: Int { get }
    
    /// Given an IndexPath, instantiates the provided recipe's view model.
    func recipeViewModel (for indexPath: IndexPath) -> RecipeViewModelProtocol
    
    // MARK: Actions & Events
    /// Signals this view model to fetch data from the network.
    func refreshData()
    /// Searches locally for either the recipe's name, ingredients or steps.
    func search (for text: String)
    /// Changes the currently used filter and updates results.
    func changeFilter (to newFilter: RecipeListFilter)
    /// Handles the recipe "on tap" event.
    func didTapRecipe (at indexPath: IndexPath)
    /// Handles a tap on the filter button.
    func didTapFilterButton()
}

protocol RecipeListViewModelDelegate: AnyObject {
    /// Notifies the view that the dataset changed and it should be updated accordingly.
    func updateScreen()
    /// Shows a network error with the possibility to retry.
    func showNetworkError (withMessage message: String)
}

protocol RecipeListViewModelCoordinatorDelegate: AnyObject {
    /// Opens the recipe detail view controller.
    func showRecipe (_ recipe: Recipe)
    /// Opens the filter selection screen.
    func openFilterSelectionScreen (withCurrentFilter currentFilter: RecipeListFilter?)
}

class RecipeListViewModel: RecipeListViewModelProtocol {
    // Use protocol composition to efficiently obtain our dependencies in one step.
    typealias Dependencies = HasApiService & HasRecipeDifficultyClassifier
    
    // MARK: Delegates
    weak var delegate: RecipeListViewModelDelegate?
    weak var coordinatorDelegate: RecipeListViewModelCoordinatorDelegate?
    
    // MARK: Properties
    
    /// View Model dependencies, containing the API service responsible for fetching data from
    /// the network and the recipe difficulty classifier.
    private let dependencies: Dependencies
    
    /// The original, unfiltered recipes.
    private var recipes: [Recipe] = [] {
        didSet {
            // Immediately update the filtered recipes once new ones are received.
            self.filterRecipes()
        }
    }
    
    /// The filtered recipes.
    ///
    /// **NOTE:** Avoid directly accessing to `filteredRecipes` and `searchedRecipes` for
    /// presentation purposes as it's error propne and could lead to wrong things being shown.
    /// Use the subscript operator for this class, e.g. `self[index]` or `self[indexPath]`.
    private var filteredRecipes: [Recipe] = []
    
    /// Recipes being filtered & searched for. This is `nil` when no search in progress.
    ///
    /// **NOTE:** Avoid directly accessing to `filteredRecipes` and `searchedRecipes` for
    /// presentation purposes as it's error propne and could lead to wrong things being shown.
    /// Use the subscript operator for this class, e.g. `self[index]` or `self[indexPath]`.
    private var searchedRecipes: [Recipe]?
    
    /// The filter currently in use. `nil` if showing all the recipes.
    private var currentFilter: RecipeListFilter? {
        didSet {
            self.filterRecipes()
        }
    }
    
    // MARK: Init
    init (dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Data Source
    var numberOfItems: Int {
        // If searching, provide the number of entries in the search-local data holder, otherwise
        // use the filtered recipes.
        return self.searchedRecipes?.count ?? self.filteredRecipes.count
    }
    
    func recipeViewModel (for indexPath: IndexPath) -> RecipeViewModelProtocol {
        return RecipeViewModel (
            recipe: self[indexPath],
            dependencies: self.dependencies
        )
    }
    
    // MARK: Events / Actions
    func refreshData() {
        // Retrieve recipes from our API Service.
        let jsonDecoder = JSONDecoder()
        // Configure the `JSONDecoder` to use the given difficulty classifier to classify recipes.
        jsonDecoder.userInfo[.recipeDifficultyClassifier] =
            self.dependencies.recipeDifficultyClassifier
        // Retrieve the recipes!
        self.dependencies.apiService.retrieveModel (
            from: APIEndpoint.getRecipes,
            withJsonDecoder: jsonDecoder
        ) { (result: Result<[Recipe], Error>) in
            switch result {
            case .success (let recipes):
                // Update the recipes and notify the controller.
                self.recipes = recipes
                self.delegate?.updateScreen()
            case .failure (let error):
                // Let the controller know that something went wrong.
                self.delegate?.showNetworkError (withMessage: error.localizedDescription)
            }
        }
        // The fetching of recipe images is delegated to the single recipes' view models.
    }
    
    func search (for text: String) {
        if text.isEmpty {
            // restore original results
            self.searchedRecipes = nil
        } else {
            self.searchedRecipes = self.filteredRecipes.filter { recipe in
                // Search by recipe name, ingredient name or step description.
                return
                    recipe.name.localizedCaseInsensitiveContains (text) ||
                    recipe.ingredients.contains {
                        $0.name.localizedCaseInsensitiveContains (text)
                    } ||
                    recipe.steps.contains {
                        $0.description.localizedCaseInsensitiveContains (text)
                    }
            }
        }
        self.delegate?.updateScreen()
    }
    
    func changeFilter (to newFilter: RecipeListFilter) {
        self.currentFilter = newFilter
    }
    
    func didTapRecipe (at indexPath: IndexPath) {
        self.coordinatorDelegate?.showRecipe (self[indexPath])
    }
    
    func didTapFilterButton () {
        self.coordinatorDelegate?.openFilterSelectionScreen (
            withCurrentFilter: self.currentFilter)
    }
    
    // MARK: Private API
    
    /// Filters the recipes in a separate array used for presentation.
    private func filterRecipes() {
        guard let filter = self.currentFilter else {
            // no filtering to do if there's no filter, just passthrough
            self.filteredRecipes = self.recipes
            return
        }
        self.filteredRecipes = self.recipes.filter (filter.allows(recipe:))
        self.delegate?.updateScreen()
    }
    
    /// Retrieves a recipe indexed by `index`. Automatically uses the correct data source, whether
    /// it's search results or the whole array of filtered recipes.
    private subscript (index: Int) -> Recipe {
        return self.searchedRecipes?[index] ?? self.filteredRecipes[index]
    }
    
    /// Retrieves a recipe indexed by `indexPath`. Automatically uses the correct data source,
    /// whether it's search results or the whole array of filtered recipes.
    private subscript (indexPath: IndexPath) -> Recipe {
        return self[indexPath.row]
    }
}
