//
//  FilterPageSteps.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

extension MainTest {
    
    func thenIShouldSeeFilterPage() {
        XCTContext.runActivity(named: "Then I should see filter page") { _ in
            XCTAsyncAssert(FilterPageScreen.filterPageTitle.element, errorMessage:"Filter page was not loaded")
        }
    }
    
    func andIVerifyFilterOptions() {
        XCTContext.runActivity(named: "AndbI verify filter options") { _ in
            XCTAsyncAssert(FilterPageScreen.recipeDifficultyHeader.element, errorMessage:"Recipe difficulty header was not found")
            XCTAsyncAssert(FilterPageScreen.easy.element, errorMessage:"Easy difficulty was not found")
            XCTAsyncAssert(FilterPageScreen.medium.element, errorMessage:"Medium difficulty was not found")
            XCTAsyncAssert(FilterPageScreen.hard.element, errorMessage:"Hard difficulty was not found")
            XCTAsyncAssert(FilterPageScreen.recipeTimeHeader.element, errorMessage:"Recipe time header was not found")
            XCTAsyncAssert(FilterPageScreen.shortTime.element, errorMessage:"Short time was not found")
            XCTAsyncAssert(FilterPageScreen.mediumTime.element, errorMessage:"Medium time was not found")
            XCTAsyncAssert(FilterPageScreen.longTime.element, errorMessage:"Long time was not found")
        }
    }
    
    func whenISelectCancelButton() {
        XCTContext.runActivity(named: "When I select cancel button") { _ in
            XCTAsyncAssert(FilterPageScreen.cancelButton.element, errorMessage: "Cancel button was not displayed")
            click(FilterPageScreen.cancelButton.element)
        }
    }
    
    func andISelectRecipeDifficulty(difficultyType:String) {
        XCTContext.runActivity(named: "And I select recipe difficulty") { _ in
            
        switch(difficultyType) {
            case "Easy":
                XCTAsyncAssert(FilterPageScreen.medium.element, errorMessage:"Medium difficulty was not found")
                XCTAsyncAssert(FilterPageScreen.hard.element, errorMessage:"Hard difficulty was not found")
                click(FilterPageScreen.medium.element)
                click(FilterPageScreen.hard.element)
                break
            case "Medium":
                XCTAsyncAssert(FilterPageScreen.easy.element, errorMessage:"Easy difficulty was not found")
                XCTAsyncAssert(FilterPageScreen.hard.element, errorMessage:"Hard difficulty was not found")
                click(FilterPageScreen.easy.element)
                click(FilterPageScreen.hard.element)
                break
            case "Hard":
                XCTAsyncAssert(FilterPageScreen.easy.element, errorMessage:"Easy difficulty was not found")
                XCTAsyncAssert(FilterPageScreen.medium.element, errorMessage:"Medium difficulty was not found")
                click(FilterPageScreen.easy.element)
                click(FilterPageScreen.medium.element)
                break
            case "Easy & Medium":
                XCTAsyncAssert(FilterPageScreen.hard.element, errorMessage:"Hard difficulty was not found")
                click(FilterPageScreen.hard.element)
                break
            case "Medium & Hard":
                XCTAsyncAssert(FilterPageScreen.easy.element, errorMessage:"Easy difficulty was not found")
                click(FilterPageScreen.easy.element)
                break
            case "Easy & Hard":
                XCTAsyncAssert(FilterPageScreen.medium.element, errorMessage:"Medium difficulty was not found")
                click(FilterPageScreen.medium.element)
                break
            default:
                XCTAsyncAssert(FilterPageScreen.recipeDifficultyHeader.element, errorMessage:"Recipe difficulty header was not found")
                break
            }
            
        }
    }
    
    func andISelectRecipeDuration(timeDuration:String) {
        XCTContext.runActivity(named: "And I select recipe difficulty") { _ in
            
        switch(timeDuration) {
            case "Short":
                XCTAsyncAssert(FilterPageScreen.mediumTime.element, errorMessage:"Medium time was not found")
                XCTAsyncAssert(FilterPageScreen.longTime.element, errorMessage:"Long time was not found")
                click(FilterPageScreen.mediumTime.element)
                click(FilterPageScreen.longTime.element)
                break
            case "Medium":
                XCTAsyncAssert(FilterPageScreen.shortTime.element, errorMessage:"Short time was not found")
                XCTAsyncAssert(FilterPageScreen.longTime.element, errorMessage:"Long time was not found")
                click(FilterPageScreen.shortTime.element)
                click(FilterPageScreen.longTime.element)
                break
            case "Long":
                XCTAsyncAssert(FilterPageScreen.shortTime.element, errorMessage:"Short time was not found")
                XCTAsyncAssert(FilterPageScreen.mediumTime.element, errorMessage:"Medium time was not found")
                click(FilterPageScreen.shortTime.element)
                click(FilterPageScreen.mediumTime.element)
                break
            case "Short & Medium":
                XCTAsyncAssert(FilterPageScreen.longTime.element, errorMessage:"Long time was not found")
                click(FilterPageScreen.longTime.element)
                break
            case "Medium & Long":
                XCTAsyncAssert(FilterPageScreen.shortTime.element, errorMessage:"Short time was not found")
                click(FilterPageScreen.shortTime.element)
                break
            case "Short & Long":
                XCTAsyncAssert(FilterPageScreen.mediumTime.element, errorMessage:"Medium time was not found")
                click(FilterPageScreen.mediumTime.element)
                break
            default:
                XCTAsyncAssert(FilterPageScreen.recipeTimeHeader.element, errorMessage:"Recipe time header was not found")
                break
            }
            
        }
    }
    
    func andISelectDoneButton() {
        XCTContext.runActivity(named: "And I select done button") { _ in
            XCTAsyncAssert(FilterPageScreen.doneButton.element, errorMessage: "Done button was not displayed")
            click(FilterPageScreen.doneButton.element)
        }
    }
    
    func thenIVerifyRelevantRecipe(titleOfRecipe:String) {
        XCTContext.runActivity(named: "Then I Verify relevant recipe") { _ in
            XCTAsyncAssert(recipeCells.staticTexts[titleOfRecipe], errorMessage:"Recipe was not loaded")
        }
    }
    
}
