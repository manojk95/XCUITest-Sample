//
//  RecipeDifficultyClassifierMock.swift
//  ASOS RecipesTests
//

import Foundation
@testable import ASOS_Recipes

struct RecipeDifficultyClassifierMock: RecipeDifficultyClassifier {
    var classifyAllTo: Recipe.Difficulty = .easy
    
    init() {}
    init (classifyAllTo difficulty: Recipe.Difficulty) {
        self.classifyAllTo = difficulty
    }
    
    func difficulty (for recipe: Recipe) -> Recipe.Difficulty {
        return self.classifyAllTo
    }
}
