//
//  RecipeListCoordinatorTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class RecipeListCoordinatorTest: XCTestCase {
    var router: RouterMock!
    var sut: RecipeListCoordinator!
    
    override func setUp() {
        super.setUp()
        router = RouterMock()
        sut = RecipeListCoordinator (
            router: router,
            dependencies: AppDependencies (
                apiService: APIServiceMock(),
                recipeDifficultyClassifier: RecipeDifficultyClassifierMock()
            )
        )
    }
    
    override func tearDown() {
        sut = nil
        router = nil
        super.tearDown()
    }
    
    func testStart() {
        sut.start()
        XCTAssert (router.controllers.count == 1)
        XCTAssert (router.currentlyPresented is RecipeListViewController)
    }
    
    func testShowRecipe() {
        sut.start()
        sut.showRecipe (Recipe (
            name: "",
            ingredients: [],
            steps: [],
            imageURL: URL(fileURLWithPath: ""),
            originalURL: nil,
            difficulty: nil
        ))
        XCTAssert (router.controllers.count == 2)
        XCTAssert (router.currentlyPresented is RecipeDetailTableViewController)
    }
    
    func testRunFilterSelection() {
        sut.start()
        sut.openFilterSelectionScreen (withCurrentFilter: nil)
        XCTAssert (sut.children.count == 1)
        XCTAssert (sut.children[0] is RecipeListFilterCoordinator)
        XCTAssert (router.controllers.count == 2)
    }
}
