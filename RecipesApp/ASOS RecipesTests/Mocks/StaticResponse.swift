//
//  Data.swift
//  ASOS RecipesTests
//

import Foundation
@testable import ASOS_Recipes

enum StaticResponse {
    // TODO: add more responses
    case oneRecipe
    
    var value: String {
        switch self {
        case .oneRecipe:
            return #"""
[
  {
    "name": "Testing Recipe",
    "ingredients": [
      {
        "quantity": "1",
        "name": "Test Name",
        "type": "Test Type"
      }
    ],
    "steps": [
      "Test everything."
    ],
    "timers": [
      999
    ],
    "imageURL": "https://recipe.url"
  }
]
"""#
        }
    }
    
    var recipes: [Recipe]? {
        switch self {
        case .oneRecipe:
            return try! JSONDecoder().decode ([Recipe].self,
                                              from: self.value.data (using: .utf8)!)
        }
    }
}
