//
//  Dependencies.swift
//  ASOS Recipes
//

import Foundation

// These are a series of protocols to specify dependencies for View Models and Coordinators using
// protocol composition.
// Thanks to Krzysztof Zabłocki for inspiration.

protocol HasApiService {
    var apiService: APIServiceProtocol { get }
}

protocol HasRecipeDifficultyClassifier {
    var recipeDifficultyClassifier: RecipeDifficultyClassifier { get }
}

struct AppDependencies: HasApiService, HasRecipeDifficultyClassifier {
    let apiService: APIServiceProtocol
    let recipeDifficultyClassifier: RecipeDifficultyClassifier
}
