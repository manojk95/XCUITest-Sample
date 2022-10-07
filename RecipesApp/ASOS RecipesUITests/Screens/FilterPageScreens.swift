//
//  FilterPageScreens.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

enum FilterPageScreen: String {
    
    case filterPageTitle = "Filters"
    case doneButton = "doneButton"
    case cancelButton = "Cancel"
    case recipeDifficultyHeader = "Recipe Difficulty"
    case recipeTimeHeader = "Recipe Time"
    case easy = "easyCell"
    case medium = "mediumCell"
    case hard = "hardCell"
    case shortTime = "shortTimeCell"
    case mediumTime = "MedTimeCell"
    case longTime = "longTimeCell"
    
    var element: XCUIElement {
        
    switch self {
        case .filterPageTitle:
            return XCUIApplication().staticTexts[self.rawValue]
        case .doneButton:
            return XCUIApplication().buttons[self.rawValue]
        case .cancelButton:
            return XCUIApplication().buttons[self.rawValue]
        case .recipeDifficultyHeader:
            return XCUIApplication().staticTexts[self.rawValue]
        case .recipeTimeHeader:
            return XCUIApplication().staticTexts[self.rawValue]
        case .easy, .medium, .hard, .shortTime, .mediumTime, .longTime:
            return tableCells[self.rawValue]
        }
    }
}

