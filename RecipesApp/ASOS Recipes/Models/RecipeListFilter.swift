//
//  RecipeListFilter.swift
//  ASOS Recipes
//

import Foundation

/// Controls recipe filtering and determines which difficulties and time ranges are allowed
/// to be shown.
struct RecipeListFilter: Equatable {
    /// The allowed difficulties.
    var allowedDifficulties: Set<Recipe.Difficulty>
    
    /// The allowed time ranges.
    var allowedTimeRanges: Set<Recipe.TimeRange>
    
    /// Initializes a new "show all" recipe list filter.
    init() {
        self.allowedDifficulties = Set (Recipe.Difficulty.allCases)
        self.allowedTimeRanges = Set (Recipe.TimeRange.allCases)
    }
    
    /// Returns whether the given recipe matches the filters specified by this structure.
    ///
    /// - Parameter recipe: the recipe to verify.
    /// - Returns: `true` if the recipe satisfies the given filters, `false` otherwise.
    func allows (recipe: Recipe) -> Bool {
        return self.allowedDifficulties.contains (recipe.difficulty)
            && self.allowedTimeRanges.contains (recipe.timeRange)
    }
}
