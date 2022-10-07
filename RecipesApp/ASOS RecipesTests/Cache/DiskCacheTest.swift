//
//  DiskCacheTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class DiskCacheTest: XCTestCase {
    var sut: Cache!
    
    override func setUp() {
        super.setUp()
        do {
            sut = try DiskCache (policy: .expires (after: 2), namespace: "asos-recipes-test")
        } catch let error {
            XCTFail ("Got error during DiskCache init: \(error)")
        }
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testBasicStoreAndRetrieval() {
        CacheTester.testBasicStoreAndRetrieval (forCache: sut)
    }
    
    func testExpiration() {
        CacheTester.testExpiration (expiration: 2, forCache: sut)
    }
}
