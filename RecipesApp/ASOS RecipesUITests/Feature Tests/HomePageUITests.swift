//
//  HomePageUITests.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

class HomePageUITests: MainTest {

    
    func testVerifyRecipesDisplayedOnLaunch() {
        
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        thenIVerifyRecipeTitle()
        andIVerifyRecipeTime()
        andIVerifyRecipeIngredients()
        
    }
    
    func testVerifyParticularRecipeOnHomepage() {
        
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        thenIVerifyParticularRecipe(recipeName:"Curried chicken salad")
    }
}
