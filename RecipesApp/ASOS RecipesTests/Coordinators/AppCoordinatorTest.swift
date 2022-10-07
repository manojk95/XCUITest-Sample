//
//  AppCoordinatorTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class AppCoordinatorTest: XCTestCase {
    var router: RouterMock!
    var sut: AppCoordinator!
    
    override func setUp() {
        super.setUp()
        router = RouterMock()
        sut = AppCoordinator (router: router, dependencies: AppDependencies(
            apiService: APIServiceMock(),
            recipeDifficultyClassifier: RecipeDifficultyClassifierMock()
        ))
    }

    override func tearDown() {
        sut = nil
        router = nil
        super.tearDown()
    }

    func testAppCoordinatorCreatesChildCoordinator() {
        sut.start()
        XCTAssert (sut.children.count == 1)
    }
    
    func testAppCoordinatorDisplaysSomething() {
        sut.start()
        XCTAssert (router.currentlyPresented != nil)
    }
}
