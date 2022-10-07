//
//  RecipeDetailTableViewController.swift
//  ASOS Recipes
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    /// Represents the sections of this Table View Controller along with their section numbers.
    enum Section: Int, CaseIterable, FromIndexPath {
        case ingredients = 0, steps
    }
    
    // MARK: Instance Properties
    
    /// The image of the recipe. It is the table's header, and outlets just don't work.
    var recipeImageView: UIImageView {
        return self.tableView.tableHeaderView! as! UIImageView
    }
    
    /// This view controller's view model.
    var viewModel: RecipeViewModelProtocol! {
        didSet {
            // Subscribe to image downloading events.
            self.viewModel.delegate = self
            // Update this view controller's title.
            self.title = self.viewModel.name
            // Finally, use the image that's already available -- either the placeholder, or
            // the definitive recipe image.
            self.recipeImageView.image = self.viewModel.image
        }
    }
    
    // MARK: Table View Data Source & Delegate
    override func numberOfSections (in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        switch Section.from (sectionNumber: section) {
        case .ingredients:
            return String (format: "Ingredients (%d)", self.viewModel.numberOfIngredients)
        case .steps:
            return "Steps"
        }
    }
    
    override func tableView (_ tableView: UITableView,
                             willDisplayHeaderView view: UIView,
                             forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else {
            return
        }
        // Change the alignment of the default header text provided by iOS.
        view.textLabel?.textAlignment = .center
    }

    override func tableView (_ tableView: UITableView,
                             numberOfRowsInSection section: Int) -> Int {
        switch Section.from (sectionNumber: section) {
        case .ingredients:
            return self.viewModel.numberOfIngredients
        case .steps:
            return self.viewModel.numberOfSteps
        }
    }
    
    override func tableView (_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.from (indexPath: indexPath) {
        case .ingredients:
            // Retrieve an "ingredient" cell and populate it with data from the view model.
            let cell = tableView.dequeueReusableCell (withIdentifier: "ingredient",
                                                      for: indexPath)
            let ingredient = self.viewModel.ingredient (for: indexPath)
            cell.textLabel?.text = ingredient.name.trimmingCharacters(in: .whitespaces).capitalized
            cell.detailTextLabel?.text = ingredient.quantity
            return cell
        case .steps:
            let cell = tableView.dequeueReusableCell (withIdentifier: "step",
                                                      for: indexPath)
                as! RecipeDetailStepTableViewCell
            // Do the same as the ingredient cell.
            let step = self.viewModel.step (for: indexPath)
            cell.descriptionLabel.text = step.description
            cell.stepNumberLabel.text = String (format: "Step %d", indexPath.row + 1)
            if step.duration > 0 {
                // Format the duration appropriately.
                cell.stepDurationLabel.text = step.duration.format (withUnitsStyle: .short,
                                                                    maxUnits: 0)
            } else {
                // Don't display anything if the duration of the step is 0.
                cell.stepDurationLabel.text = ""
            }
            return cell
        }
    }
    
    // MARK: Actions
    @IBAction func onRecipeImageTapped (_ sender: UITapGestureRecognizer) {
        self.viewModel.onTap()
    }
}

extension RecipeDetailTableViewController: RecipeViewModelDelegate {
    func updateImage() {
        DispatchQueue.main.async {
            self.recipeImageView.image = self.viewModel.image
        }
    }
}
