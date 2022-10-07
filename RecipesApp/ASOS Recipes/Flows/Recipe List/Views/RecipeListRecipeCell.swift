//
//  RecipeListRecipeCell.swift
//  ASOS Recipes
//

import UIKit

class RecipeListRecipeCell: UICollectionViewCell {
    // MARK: Instance Properties
    
    /// This cell's view model.
    var viewModel: RecipeViewModelProtocol! {
        didSet {
            // Receive updates from the view model.
            self.viewModel.delegate = self
            // Update our data with the view model's data.
            self.titleLabel.text = self.viewModel.name
            // TODO: proper localization / pluralization.
            self.ingredientsLabel.text = String(format: "%d ingredients",
                                                self.viewModel.numberOfIngredients)
            self.durationLabel.text = self.viewModel.roundedFormattedDuration
            self.image.image = self.viewModel.image
        }
    }
    
    // MARK: Outlets
    @IBOutlet var image: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ingredientsLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
}

extension RecipeListRecipeCell: RecipeViewModelDelegate {
    func updateImage() {
        DispatchQueue.main.async {
            self.image.image = self.viewModel.image
        }
    }
}
