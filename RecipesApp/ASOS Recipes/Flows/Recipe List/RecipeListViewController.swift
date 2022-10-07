//
//  ViewController.swift
//  ASOS Recipes
//

import UIKit

class RecipeListViewController: UIViewController {
    // MARK: Class Properties
    
    /// Configures the UI layout of this view. Particularly, this defines how many recipes per row
    /// are shown according to each horizontal size class. On larger devices (or in landscape),
    /// 4 cells are shown per row, otherwise just 2. The sizing is calculated automatically by
    /// our implementation of `UICollectionViewDelegateFlowLayout`.
    private static let CELLS_PER_ROW: [UIUserInterfaceSizeClass: Int] = [
        .compact: 2,
        .regular: 4
    ]
    
    /// Whether a size class is not determined (yet), this is the value that will be used to
    /// place the cells in a row.
    private static let DEFAULT_CELLS_PER_ROW = 4
    
    // MARK: Instance Properties
    
    /// This view controller's view model. Injected by the coordinator.
    var viewModel: RecipeListViewModelProtocol! {
        didSet {
            // Bind the view model to this controller for two-way communication.
            self.viewModel.delegate = self
        }
    }
    
    /// The `SearchController` used to handle search in this view.
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController (searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    /// The refresh control responsible for pull-to-refresh and showing the loading.
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        // Let the RefreshControl notify us when changing state.
        refreshControl.addTarget (self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add the refresh control.
        self.collectionView.addSubview (self.refreshControl)
        // Add the search controller to the `navigationItem`.
        self.navigationItem.searchController = self.searchController
        // Enable the refresh controller to signal that we're going to have data soon.
        self.refreshControl.beginRefreshing()
        // Always show the search bar.
        // NOTE: to be honest, hiding the search bar while scrolling would've been cooler, but
        // I want the search bar to be visible by default when opening the app, and there's no
        // way to do that without ugly (and non reliable) hacks.
        self.navigationItem.hidesSearchBarWhenScrolling = false
        // Let the view model know that we're ready to receive data.
        self.viewModel.refreshData()
    }
    
    // MARK: Actions
    @IBAction func onFilterButton (_ sender: UIBarButtonItem) {
        self.viewModel.didTapFilterButton()
    }
    
    // MARK: Methods
    @objc private func refresh (_ refreshControl: UIRefreshControl) {
        self.viewModel.refreshData()
    }
    
    // MARK: Outlets
    @IBOutlet var collectionView: UICollectionView!
}

// MARK: UICollectionViewDataSource
extension RecipeListViewController: UICollectionViewDataSource {
    func collectionView (_ collectionView: UICollectionView,
                         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell (withReuseIdentifier: "recipe",
                                                       for: indexPath) as! RecipeListRecipeCell
        // Assign the correct view model for this cell.
        cell.viewModel = self.viewModel.recipeViewModel (for: indexPath)
        return cell
    }
    
    func numberOfSections (in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView (_ collectionView: UICollectionView,
                         numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension RecipeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView (_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerRow = CGFloat (
            RecipeListViewController.CELLS_PER_ROW[self.traitCollection.horizontalSizeClass]
                ?? RecipeListViewController.DEFAULT_CELLS_PER_ROW
        )
        
        // Thanks to Gagandeep Gambhir @ SO for inspiration.
        // Calculate the total spacing between cells.
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * (cellsPerRow - 1)
        
        // Finally, calculate the (single) cell's size.
        let size = Int ((collectionView.bounds.width - totalSpace) / cellsPerRow)

        return CGSize (width: size, height: size)
    }
    
    func collectionView (_ collectionView: UICollectionView,
                         didSelectItemAt indexPath: IndexPath) {
        // Open the tapped recipe.
        self.viewModel.didTapRecipe (at: indexPath)
    }
}

// MARK: UISearchResultsUpdating
extension RecipeListViewController: UISearchResultsUpdating {
    func updateSearchResults (for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.viewModel.search (for: searchText)
        }
    }
}

// MARK: RecipeListViewModelViewDelegate
extension RecipeListViewController: RecipeListViewModelDelegate {
    func updateScreen() {
        DispatchQueue.main.async {
            // The ViewModel notified of new data -- stop the refresh controller if animating and
            // update the collection view.
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func showNetworkError (withMessage message: String) {
        DispatchQueue.main.async {
            // Create an alert controller with the message.
            let alert = UIAlertController (
                title: "Error",
                message: String (format: "Something went wrong. %@", message),
                preferredStyle: .alert
            )
            // We really don't want the user to roam around the app with incomplete network
            // information. Just show the "Retry" button.
            alert.addAction (
                UIAlertAction (title: "Retry", style: .default) { alert in
                    self.viewModel.refreshData()
                }
            )
            self.present (alert, animated: true)
        }
    }
}
