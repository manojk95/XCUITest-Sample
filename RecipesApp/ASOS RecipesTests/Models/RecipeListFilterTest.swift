//
//  RecipeListFilterTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class RecipeListFilterTest: XCTestCase {
    var sut: RecipeListFilter!
    var recipe: Recipe!
    
    override func setUp() {
        super.setUp()
        recipe = Recipe (
            name: "",
            ingredients: [],
            steps: [],
            imageURL: URL (fileURLWithPath: ""),
            originalURL: nil,
            difficulty: .hard
        )
        sut = RecipeListFilter()
    }
    
    override func tearDown() {
        recipe = nil
        sut = nil
        super.tearDown()
    }
    
    func testDifficultyFilter() {
        sut.allowedDifficulties = [.easy]
        XCTAssertFalse (sut.allows (recipe: recipe))
        sut.allowedDifficulties = [.medium, .hard]
        XCTAssert (sut.allows (recipe: recipe))
    }
    
    func testTimeRangeFilter() {
        sut.allowedTimeRanges = [.zeroToTen]
        XCTAssert (sut.allows (recipe: recipe))
        sut.allowedTimeRanges = [.tenToTwenty]
        XCTAssertFalse (sut.allows (recipe: recipe))
    }
    
    func testAllFilters() {
        sut.allowedDifficulties = [.hard]
        sut.allowedTimeRanges = [.zeroToTen]
        XCTAssert (sut.allows (recipe: recipe))
        sut.allowedTimeRanges.removeAll()
        XCTAssertFalse (sut.allows (recipe: recipe))
    }
}
