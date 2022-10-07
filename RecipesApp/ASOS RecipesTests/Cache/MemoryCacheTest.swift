//
//  MemoryCacheTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class MemoryCacheTest: XCTestCase {
    var sut: MemoryCache!
    
    override func setUp() {
        super.setUp()
        sut = MemoryCache (policy: .expires (after: 1)) // 1 second expiration
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testBasicStoreAndRetrieval() {
        CacheTester.testBasicStoreAndRetrieval (forCache: sut)
    }
    
    func testExpiration() {
        CacheTester.testExpiration (expiration: 1, forCache: sut)
    }
}
