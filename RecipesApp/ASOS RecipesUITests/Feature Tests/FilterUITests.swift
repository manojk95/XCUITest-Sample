//
//  FilterUITests.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

class FilterUITests: MainTest {

    func testVerifyFilterOptions() {
        
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        whenISelectFilterButton()
        thenIShouldSeeFilterPage()
        andIVerifyFilterOptions()
        whenISelectCancelButton()
        thenIVerifyRecipeTitle()
    }
    
    func testVerifySuccessFilterOption() {
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        whenISelectFilterButton()
        andISelectRecipeDifficulty(difficultyType:"Hard")
        andISelectRecipeDuration(timeDuration:"Long")
        andISelectDoneButton()
        thenIVerifyRelevantRecipe(titleOfRecipe:"Old-Fashioned Oatmeal Cookies")
    }
}
