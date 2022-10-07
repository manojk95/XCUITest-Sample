//
//  RecipePageElements.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

let tableCells = XCUIApplication().tables.cells
let imageLink = XCUIApplication().tables.images.matching(identifier: "imageLink").element
enum RecipePageScreen: String {
    
    case navBarTitle = "Crock Pot Roast"
    case recipesButton = "Recipes"
    case ingredientsHeader = "Ingredients"
    case stepsHeader = "Steps"
    case stepsList = "Step 1"
    
    var element: XCUIElement {
        
    switch self {
        case .navBarTitle:
            return XCUIApplication().navigationBars.staticTexts[self.rawValue]
        case .recipesButton:
            return XCUIApplication().navigationBars.buttons[self.rawValue]
        case .ingredientsHeader:
            let predicate = NSPredicate(format: "label CONTAINS '"+self.rawValue+"'")
            return tableCells.staticTexts.containing(predicate).firstMatch
        case .stepsHeader, .stepsList:
            return tableCells.staticTexts[self.rawValue]
        }
        
    }
}
