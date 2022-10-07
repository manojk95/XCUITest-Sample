//
//  RecipeListFilterCoordinatorTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class RecipeListFilterCoordinatorTest: XCTestCase {
    var router: RouterMock!
    var sut: RecipeListFilterCoordinator!
    
    override func setUp() {
        super.setUp()
        router = RouterMock()
        sut = RecipeListFilterCoordinator (
            router: router,
            filter: nil
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
        XCTAssert (router.currentlyPresented is UINavigationController)
        let navigationController = router.currentlyPresented as! UINavigationController
        XCTAssert (
            navigationController.topViewController is RecipeFilterSelectionTableViewController
        )
    }
    
    func testFinish() {
        sut.start()
        sut.onComplete = { filter in // synchronous callback
            XCTAssertNil (filter)
        }
        sut.filterViewFinished (result: nil)
        XCTAssertNil (router.currentlyPresented)
    }
}
