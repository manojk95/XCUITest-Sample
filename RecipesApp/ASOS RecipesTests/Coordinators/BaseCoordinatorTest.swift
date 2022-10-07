//
//  BaseCoordinatorTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class BaseCoordinatorTest: XCTestCase {
    private var sut: BaseCoordinator!
    
    final class CoordinatorMock: Coordinator {
        func start() {}
    }
    
    override func setUp() {
        super.setUp()
        sut = BaseCoordinator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testChildren() {
        let coordinator = CoordinatorMock()
        // insertion
        sut.addChild (coordinator)
        XCTAssertTrue (sut.children.count == 1)
        XCTAssertTrue (sut.children[0] === coordinator)
        // ensure nothing gets removed by accident
        sut.removeChild (nil)
        XCTAssertTrue (sut.children.count == 1)
        // different instance
        sut.removeChild (CoordinatorMock())
        XCTAssertTrue (sut.children.count == 1,
                       "different instances of same class aren't treated distinctly")
        // removal
        sut.removeChild (coordinator)
        XCTAssertTrue (sut.children.isEmpty)
        sut.removeChild (coordinator)
        XCTAssertTrue (sut.children.isEmpty, "double removal isn't no-op")
    }

    func testDuplicateHandling() {
        let coordinator = CoordinatorMock()
        sut.addChild (coordinator)
        sut.addChild (coordinator)
        XCTAssertTrue (sut.children.count == 1,
                       "duplicate coordinators aren't deduped")
    }
}
