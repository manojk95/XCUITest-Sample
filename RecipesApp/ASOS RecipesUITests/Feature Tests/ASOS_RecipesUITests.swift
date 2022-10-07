//
//  ASOS_RecipesUITests.swift
//  ASOS RecipesUITests
//
//  Created by Tatjana Domke on 21/02/2020.
//  Copyright © 2020 Roberto Frenna. All rights reserved.
//

import XCTest

class ASOS_RecipesUITests: MainTest {

    func testRecipesDisplayedOnLaunch() {
        let recipeCells = app.collectionViews.element.cells
        
        let recipeCell = recipeCells.element(boundBy: 0)
        
        let title = recipeCell.staticTexts["title"]
        let duration = recipeCell.staticTexts["duration"]
        let ingredients = recipeCell.staticTexts["ingredients"]
        
        XCTAssertTrue(recipeCells.count > 0, "No recipe cells were displayed")
        
        XCTAssertTrue(title.exists, "Title was not displayed")
        XCTAssertTrue(duration.exists, "Duration was not displayed")
        XCTAssertTrue(ingredients.exists, "Ingredients was not displayed")
                      
    }
}
