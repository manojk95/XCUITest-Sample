//
//  HomePageElements.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

let recipeCells = XCUIApplication().collectionViews.element.cells
let recipeCell = recipeCells.element(boundBy: 0)
let swipeReference = recipeCells.element(boundBy: 4)
enum HomePageScreen: String {
    
    case homePageTitle = "Recipes"
    case filterButton = "Filter"
    case searchBar = "Search"
    case searchBarCancelButton = "Cancel"
    case recipeTitle = "title"
    case recipeTime = "duration"
    case recipeIngredients = "ingredients"
    
    var element: XCUIElement {
        
    switch self {
        case .homePageTitle:
            return XCUIApplication().staticTexts[self.rawValue]
        case .filterButton:
            return XCUIApplication().buttons[self.rawValue]
        case .searchBar:
            return XCUIApplication().searchFields[self.rawValue]
        case .searchBarCancelButton:
            return XCUIApplication().buttons[self.rawValue]
        case .recipeTitle, .recipeTime, .recipeIngredients:
            return recipeCell.staticTexts[self.rawValue]
        }
    }
}
