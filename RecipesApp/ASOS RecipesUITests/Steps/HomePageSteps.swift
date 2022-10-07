//
//  HomePageSteps.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

extension MainTest {
    
    func givenIAmOnHomePage() {
        XCTContext.runActivity(named: "Given I am on homepage") { _ in
            XCTAsyncAssert(HomePageScreen.homePageTitle.element, errorMessage:"Homepage Title was not Displayed")
        }
    }
    
    func andIShouldSeeRecipesLoaded() {
        XCTContext.runActivity(named: "And I should see recipes loaded") { _ in
            XCTAssertTrue(recipeCells.count > 0, "No recipe cells were displayed")
        }
    }
    
    func thenIVerifyRecipeTitle() {
        XCTContext.runActivity(named: "Then I verify recipe title") { _ in
            XCTAsyncAssert(HomePageScreen.recipeTitle.element, errorMessage: "Recipe Title was not displayed")
        }
    }
    
    func andIVerifyRecipeTime() {
        XCTContext.runActivity(named: "And I verify recipe time") { _ in
            XCTAsyncAssert(HomePageScreen.recipeTime.element , errorMessage: "Recipe Time was not displayed")
        }
    }
    
    func andIVerifyRecipeIngredients() {
        XCTContext.runActivity(named: "And I verify recipe ingredients") { _ in
            XCTAsyncAssert(HomePageScreen.recipeIngredients.element, errorMessage: "Recipe Time was not displayed")
        }
    }
    
    func thenIVerifyParticularRecipe(recipeName:String) {
        XCTContext.runActivity(named: "Then I verify particular recipe") { _ in
            let particularRecipe = recipeCells.staticTexts[recipeName]
            swipeUntilFound(swipeReference,particularRecipe)
            XCTAsyncAssert(particularRecipe, errorMessage: "The particular recipe is not found")
        }
    }
    
    func whenISelectTheRecipe() {
        XCTContext.runActivity(named: "When I select the recipe") { _ in
            XCTAsyncAssert(HomePageScreen.recipeTitle.element, errorMessage: "Recipe Title was not displayed")
            click(HomePageScreen.recipeTitle.element)
        }
    }
    
    func whenISelectFilterButton() {
        XCTContext.runActivity(named: "When I select filter button") { _ in
            XCTAsyncAssert(HomePageScreen.filterButton.element, errorMessage: "Filter button was not clickable")
            click(HomePageScreen.filterButton.element)
        }
    }
    
    func andIVerifySearchBar() {
        XCTContext.runActivity(named: "And I verify search bar") { _ in
            XCTAsyncAssert(HomePageScreen.searchBar.element, errorMessage:"Search bar was not Displayed")
        }
    }
    
    func whenISelectSearchBar() {
        XCTContext.runActivity(named: "When I select search bar") { _ in
            XCTAsyncAssert(HomePageScreen.searchBar.element, errorMessage:"Search bar was not Displayed")
            click(HomePageScreen.searchBar.element)
        }
    }
    
    func andISelectCancelButton() {
        XCTContext.runActivity(named: "And I select cancel button") { _ in
            XCTAsyncAssert(HomePageScreen.searchBarCancelButton.element, errorMessage:"Search bar cancel button was not Displayed")
            click(HomePageScreen.searchBarCancelButton.element)
        }
    }
    
    func whenISendKeywordToSearchField(keyword:String) {
        XCTContext.runActivity(named: "When I send keword to search field") { _ in
            XCTAsyncAssert(HomePageScreen.searchBar.element, errorMessage:"Search bar was not Displayed")
            enterText(HomePageScreen.searchBar.element, value: keyword)
        }
    }
    
    func thenIVerifyRelevantSearchResult(keyword:String) {
        XCTContext.runActivity(named: "Then I verify relevant search result") { _ in
            XCTAsyncAssert(HomePageScreen.recipeTitle.element, errorMessage:"No Search Found")
            let title = HomePageScreen.recipeTitle.element.label
            XCTAssertTrue(keyword == title,"No matching search found and test failed")
        }
    }
    
}

