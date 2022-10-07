//
//  SearchUITests.swift
//  ASOS RecipesUITests
//
//  Created by Manoj Kumar Barik on 20/05/2022.
//  Copyright © 2022 Roberto Frenna. All rights reserved.
//

import Foundation
import XCTest

class SearchUITests: MainTest {

    func testVerifySearchCancel() {
        
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        andIVerifySearchBar()
        whenISelectSearchBar()
        andISelectCancelButton()
        thenIVerifyRecipeTitle()
        
    }
    
    func testVerifyParticularSearchResult() {
        givenIAmOnHomePage()
        andIShouldSeeRecipesLoaded()
        whenISendKeywordToSearchField(keyword: "Pizza")
        thenIVerifyRelevantSearchResult(keyword: "Big Night Pizza")
    }
}
