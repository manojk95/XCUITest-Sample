//
//  RecipeListFilterViewModel.swift
//  ASOS Recipes
//

import Foundation

protocol RecipeListFilterViewModelProtocol {
    /// This view model's delegate, to be assigned in the associated `ViewController`.
    var delegate: RecipeListFilterViewModelDelegate? { get set }
    
    /// Given an `IndexPath`, returns `true` whether there's a filter specified by that index
    /// path.
    func hasFilter (at indexPath: IndexPath) -> Bool
    
    /// Given an `IndexPath`, toggles the filter specified by that index path and returns the new
    /// value. Note that this method keeps the number of filters to at least one per each
    /// category.
    func toggleFilter (at indexPath: IndexPath) -> Bool
    
    /// Handler for the "cancel" modal button. This should discard all changes.
    func onCancel()
    
    /// Handler for the "finish" modal button. This should save the changes.
    func onFinish()
}

protocol RecipeListFilterViewModelCoordinatorDelegate: AnyObject {
    /// Signals the coordinator that the filter view is done.
    ///
    /// - Parameter result: If `nil`, it is interpreted as an user-triggered cancellation of
    ///                     the modal, and the value is discarded. Otherwise, the new filter
    ///                     is propagated to the recipe list.
    func filterViewFinished (result: RecipeListFilter?)
}

/// Specifies the possible categories/types for filters.
enum RecipeListFilterViewModelFilterType {
    case difficulty, timeRange
}

protocol RecipeListFilterViewModelDelegate: AnyObject {
    /// Resolves an `IndexPath` (usually by looking at its section) returning the corresponding
    /// filter category.
    ///
    /// - Parameter indexPath: The index path to resolve.
    /// - Returns: The filter type associated to that index path.
    func resolveFilterType (with indexPath: IndexPath) -> RecipeListFilterViewModelFilterType
}

// MARK: Extensions
// This extends the sets of `RawRepresentable` enums with `Integer` `rawValues`, which
// is the exact type used by `Recipe.TimeRange` and `Recipe.Difficulty`.
extension Set where Element: RawRepresentable, Element.RawValue == Int {
    /// "Toggles" the element `element` in the set, which means that if it already exists in the
    /// set it is removed and `false` is returned, otherwise it is added and `true` is returned.
    /// Keeps at least `minimum` elements in the set. (or none if `0` is specified)
    ///
    /// - Parameter element: The element to add or remove from the set.
    /// - Parameter minimum: The minimum number of elements to keep in the set, from which removal
    ///                      will be refused (by returning `true` even if the element should
    ///                      have been removed).
    /// - Returns: `true` if the element was added (or is present), `false` if not.
    fileprivate mutating func toggle (_ element: Element, keepAtLeast minimum: Int = 1) -> Bool {
        if self.contains (element) {
            if minimum > 0, self.count == minimum {
                return true // don't allow the set to have less than `minimum` elements.
            }
            self.remove (element)
            return false
        } else {
            self.insert (element)
            return true
        }
    }
}

// MARK: RecipeListFilterViewModel
class RecipeListFilterViewModel: RecipeListFilterViewModelProtocol {
    // MARK: Delegates
    weak var coordinatorDelegate: RecipeListFilterViewModelCoordinatorDelegate?
    weak var delegate: RecipeListFilterViewModelDelegate?
    
    // MARK: Instance Properties
    
    /// The current filter. This is `null` when there's no filter currently being applied.
    private var currentFilter: RecipeListFilter?
    
    // MARK: Init
    init (currentFilter: RecipeListFilter?) {
        self.currentFilter = currentFilter
    }
    
    // MARK: Data source
    func hasFilter (at indexPath: IndexPath) -> Bool {
        // Resolve the given IndexPath.
        guard let filter     = self.currentFilter,
              let filterType = self.delegate?.resolveFilterType (with: indexPath) else {
            return true // all turned on by default
        }
        // Check the existence of the specified filter.
        switch filterType {
        case .difficulty:
            let value = Recipe.Difficulty (rawValue: indexPath.row)!
            return filter.allowedDifficulties.contains (value)
        case .timeRange:
            let value = Recipe.TimeRange (rawValue: indexPath.row)!
            return filter.allowedTimeRanges.contains (value)
        }
    }
    
    func toggleFilter (at indexPath: IndexPath) -> Bool {
        if self.currentFilter == nil {
            // If there's still no filter, create a default instance with all the filters
            // enabled.
            self.currentFilter = RecipeListFilter()
        }
        // Resolve the given IndexPath.
        guard let filterType = self.delegate?.resolveFilterType (with: indexPath) else {
            return true
        }
        // Use the extended method `toggle` in Set<T> to reduce duplicated code to a minimum.
        switch filterType {
        case .difficulty:
            let value = Recipe.Difficulty (rawValue: indexPath.row)!
            return self.currentFilter!.allowedDifficulties.toggle (value)
        case .timeRange:
            let value = Recipe.TimeRange (rawValue: indexPath.row)!
            return self.currentFilter!.allowedTimeRanges.toggle (value)
        }
    }
    
    // MARK: Actions / Events
    func onCancel() {
        self.coordinatorDelegate?.filterViewFinished (result: nil)
    }
    
    func onFinish() {
        // NOTE: while it is true that `currentFilter` can be nil to signal "all filters enabled",
        // the only possibility of it being such is when no filters have been changed yet.
        // As such, it's perfectly fine to pass it to `filterViewFinished` (which discards
        // `nil` values).
        self.coordinatorDelegate?.filterViewFinished (result: self.currentFilter)
    }
}
