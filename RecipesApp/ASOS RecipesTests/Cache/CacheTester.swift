//
//  CacheTester.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

struct CacheTester {
    static func testBasicStoreAndRetrieval (forCache sut: Cache) {
        let dataObject = Data (0...3)
        let exp = XCTestExpectation (description: "Cache fetch is successful")
        sut.store (key: "test-store", data: dataObject) { error in
            XCTAssertNil (error)
            sut.retrieve (key: "test-store") { result in
                switch result {
                case .failure (let error):
                    XCTFail (String (describing: error))
                case .success (let retrievedData):
                    XCTAssertEqual (dataObject, retrievedData)
                    exp.fulfill()
                }
            }
        }
        _ = XCTWaiter.wait (for: [exp], timeout: 5)
    }
    
    static func testExpiration (expiration: TimeInterval, forCache sut: Cache) {
        let testExp = XCTestExpectation (description: "Cache expire after \(expiration) second")
        let waitExp = XCTestExpectation (description: "Wait \(expiration) seconds")
        sut.store (key: "test-expiration", data: Data()) { error in
            XCTAssertNil (error)
            if case .timedOut = XCTWaiter.wait (for: [waitExp], timeout: expiration) {
                sut.retrieve (key: "test-expiration") { result in
                    switch result {
                    case .failure (.keyExpired), .failure (.keyNotFound):
                        testExp.fulfill()
                    default:
                        XCTFail ("Cache entry did not expire as expected")
                    }
                }
            }
        }
        _ = XCTWaiter.wait (for: [testExp], timeout: max (5, expiration))
    }
}
