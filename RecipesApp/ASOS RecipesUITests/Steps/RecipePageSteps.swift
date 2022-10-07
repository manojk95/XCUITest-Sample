//
//  RecipePageSteps.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

extension MainTest {
    
    func thenIVerifyRecipeHeader() {
        XCTContext.runActivity(named: "Then I verify recipe header") { _ in
            XCTAsyncAssert(RecipePageScreen.navBarTitle.element, errorMessage:"Recipe header was not Displayed")
        }
    }
    
    func andIVerifyIngredientsOfRecipe() {
        XCTContext.runActivity(named: "And I verify ingredients of recipe") { _ in
            XCTAsyncAssert(RecipePageScreen.ingredientsHeader.element, errorMessage:"Ingredients header was not Displayed")
            XCTAssertTrue(tableCells.count > 0, "Ingredients list not loaded")
        }
    }
    
    func andIVerifyStepsOfRecipe() {
        XCTContext.runActivity(named: "And I verify steps of recipe") { _ in
            XCTAsyncAssert(RecipePageScreen.stepsHeader.element, errorMessage:"Steps header was not Displayed")
            XCTAsyncAssert(RecipePageScreen.stepsList.element, errorMessage:"Steps not loaded")
        }
    }
    
    func whenISelectRecipesButtonOnNavigationBar() {
        XCTContext.runActivity(named: "When I select recipe button on navigation bar") { _ in
            XCTAsyncAssert(RecipePageScreen.recipesButton.element, errorMessage: "Recipes button was not displayed")
            click(RecipePageScreen.recipesButton.element)
        }
    }
    
    func andISelectRecipeLinkImage() {
        XCTContext.runActivity(named: "And I select recipe link image") { _ in
            print(imageLink)
            XCTAsyncAssert(imageLink, errorMessage: "Link is not available")
            click(imageLink)
        }
    }
}
