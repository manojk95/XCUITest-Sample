//
//  FromIndexPathTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class FromIndexPathTest: XCTestCase {
    enum TestSubject: Int, FromIndexPath {
        case zero, one
    }
    
    func testInstantiationWithIndexPath() {
        XCTAssertEqual (
            TestSubject.from (indexPath: IndexPath (row: 0, section: 0)),
            TestSubject.zero
        )
        XCTAssertEqual (
            TestSubject.from (indexPath: IndexPath (row: 0, section: 1)),
            TestSubject.one
        )
    }
    
    func testInstantiationWithSectionNumber() {
        XCTAssertEqual (
            TestSubject.from (sectionNumber: 0),
            TestSubject.zero
        )
        XCTAssertEqual (
            TestSubject.from (sectionNumber: 1),
            TestSubject.one
        )
    }
}
