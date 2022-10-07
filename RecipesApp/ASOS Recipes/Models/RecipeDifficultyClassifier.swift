//
//  RecipeDifficultyQuantifier.swift
//  ASOS Recipes
//

import Foundation

protocol RecipeDifficultyClassifier {
    func difficulty (for recipe: Recipe) -> Recipe.Difficulty
}

struct StepAndIngredientCountRecipeDifficultyClassifier: RecipeDifficultyClassifier {
    func difficulty (for recipe: Recipe) -> Recipe.Difficulty {
        // As a basic classifier, sum the step and ingredient count and assign a difficulty to
        // the result.
        let coefficient = recipe.steps.count + recipe.ingredients.count
        switch coefficient {
        case 0...10:
            return .easy
        case 11...20:
            return .medium
        default:
            return .hard
        }
    }
}
