//
//  RecipeFilterSelectionTableViewController.swift
//  ASOS Recipes
//

import UIKit

class RecipeFilterSelectionTableViewController: UITableViewController {
    /// Represents the sections of this Table View Controller along with their section numbers.
    enum Section: Int, FromIndexPath {
        case difficulty = 0, timeRange
    }
    
    // MARK: Instance Properties
    /// This view controller's view model.
    var viewModel: RecipeListFilterViewModelProtocol! {
        didSet {
            self.viewModel.delegate = self
        }
    }
    
    // MARK: Actions
    @IBAction func onCancelButton (_ sender: UIBarButtonItem) {
        self.viewModel?.onCancel()
    }
    
    @IBAction func onDoneButton (_ sender: UIBarButtonItem) {
        self.viewModel?.onFinish()
    }
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Restore the user selected filter types.
        let cell = super.tableView (tableView, cellForRowAt: indexPath)
        
        // Let the view model handle all the work.
        cell.accessoryType = self.viewModel.hasFilter (at: indexPath) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        // `toggleFilter` returns the new boolean value for the accessory of the selected row.
        let wasAdded = self.viewModel.toggleFilter (at: indexPath)
        tableView.cellForRow (at: indexPath)?.accessoryType = wasAdded ? .checkmark : .none
        tableView.deselectRow (at: indexPath, animated: true)
    }
}

extension RecipeFilterSelectionTableViewController: RecipeListFilterViewModelDelegate {
    func resolveFilterType (with indexPath: IndexPath) -> RecipeListFilterViewModelFilterType {
        // Yes -- this maps enumerations with the same member names, however there's really
        // no way to let the ViewModel know about our enumeration and use it.
        switch Section.from (indexPath: indexPath) {
        case .difficulty:
            return .difficulty
        case .timeRange:
            return .timeRange
        }
    }
}
