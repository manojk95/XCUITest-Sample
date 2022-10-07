//
//  RecipeViewModel.swift
//  ASOS Recipes
//

import UIKit

protocol RecipeViewModelProtocol {
    /// The delegate responsible for responding to this View Model's events.
    var delegate: RecipeViewModelDelegate? { get set }
    
    /// The recipe name.
    var name: String { get }
    
    /// Public-facing recipe formatted duration. This uses full formatting and allows up to one
    /// unit to be shown, with rounding. (e.g. 1h45min is expressed as "2 hours").
    ///
    /// **NOTE**: only use this when an approximate representation of time is sufficient.
    var roundedFormattedDuration: String { get }
    
    /// The recipe image.
    var image: UIImage { get set }
    
    /// The number of ingredients available in this recipe.
    var numberOfIngredients: Int { get }
    /// Accesses this recipe's ingredients, indexed by the given `IndexPath`.
    func ingredient (for indexPath: IndexPath) -> Recipe.Ingredient
    
    /// The number of steps needed to perform this recipe.
    var numberOfSteps: Int { get }
    /// Accesses this recipe's steps, indexed by the given `IndexPath`.
    func step (for indexPath: IndexPath) -> Recipe.Step
    
    // MARK: Actions / Events
    /// Tap gesture handler for this recipe, which opens its original URL (if available) in the
    /// user's browser.
    func onTap()
}

protocol RecipeViewModelCoordinatorDelegate: AnyObject {
    /// Opens this recipe's original URL in the user's preferred browser.
    ///
    /// - Parameter url: The recipe URL.
    func navigate (toRecipeURL url: URL)
}

protocol RecipeViewModelDelegate: AnyObject {
    /// Notifies the view that this view model's image changed.
    func updateImage()
}

/// The default placeholder image used while loading or when the loading fails.
fileprivate let PLACEHOLDER_IMAGE = UIImage (named: "placeholder.jpg")! // automatically lazy

class RecipeViewModel: RecipeViewModelProtocol {
    // Use protocol composition to efficiently obtain our dependencies in one step.
    typealias Dependencies = HasApiService
    
    // MARK: Delegates
    weak var delegate: RecipeViewModelDelegate?
    weak var coordinatorDelegate: RecipeViewModelCoordinatorDelegate?
    
    /// The recipe managed by this view model.
    private let recipe: Recipe
    
    /// This view model's dependencies (the API service).
    private let dependencies: Dependencies
    
    // MARK: Public API
    var name: String {
        return self.recipe.name
    }
    
    var roundedFormattedDuration: String {
        return self.recipe.duration.format (withUnitsStyle: .full, maxUnits: 1) ?? "N/A"
    }
    
    var image = PLACEHOLDER_IMAGE
    
    var numberOfIngredients: Int {
        return self.recipe.ingredients.count
    }
    
    var numberOfSteps: Int {
        return self.recipe.steps.count
    }
    
    // MARK: Init
    init (recipe: Recipe, dependencies: Dependencies) {
        self.recipe = recipe
        self.dependencies = dependencies
        // Immediately start to fetch the image associated to this recipe.
        // NOTE: `apiService` transparently handles caching -- once an image is downloaded
        // it is cached and not redownloaded.
        dependencies.apiService.makeRequest (to: recipe.imageURL) { [weak self] result in
            // Make sure to not keep this View Model alive only because of a pending download.
            guard let strongSelf = self else {
                // The result will still be useful later if this view controller is
                // instantiated again, as everything is cached.
                return
            }
            switch result {
            case .success (let data):
                // If we have (supposedly) image data, decode it and update our local reference,
                // letting our delegate know.
                if let image = UIImage (data: data) {
                    strongSelf.image = image
                    strongSelf.delegate?.updateImage()
                } else {
                    // Silently show a warning when an image fails decoding.
                    // TODO: Cache failures? We don't really want to spam a webservice if it's
                    // already failing.
                    debugPrint ("WARNING: couldn't decode image for \(recipe.imageURL)")
                }
            case .failure (let error):
                debugPrint ("Got error while fetching image for \(recipe.imageURL)!", error)
            }
        }
    }
    
    // MARK: Data Source
    func ingredient (for indexPath: IndexPath) -> Recipe.Ingredient {
        return self.recipe.ingredients[indexPath.row]
    }
    
    func step (for indexPath: IndexPath) -> Recipe.Step {
        return self.recipe.steps[indexPath.row]
    }
    
    // MARK: Actions / Events
    func onTap() {
        if let originalUrl = recipe.originalURL {
            self.coordinatorDelegate?.navigate (toRecipeURL: originalUrl)
        }
    }
}
