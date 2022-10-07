//
//  CachedAPIServiceTest.swift
//  ASOS RecipesTests
//

import XCTest
@testable import ASOS_Recipes

class CachedAPIServiceTest: XCTestCase {
    var sut: CachedAPIService!
    var cacheMock: CacheMock!
    var networkFetcherMock: FakeNetworkFetcher!
    
    override func setUp() {
        super.setUp()
        cacheMock = CacheMock()
        networkFetcherMock = FakeNetworkFetcher()
        sut = CachedAPIService (
            cache: cacheMock,
            networkFetcher: networkFetcherMock
        )
    }
    
    override func tearDown() {
        sut = nil
        networkFetcherMock = nil
        cacheMock = nil
        super.tearDown()
    }
    
    func testModelRequest() {
        networkFetcherMock.handler = { url in
            XCTAssertEqual (url, APIEndpoint.getRecipes.url!)
            return .success (StaticResponse.oneRecipe.value.data (using: .utf8)!)
        }
        sut.retrieveModel (from: APIEndpoint.getRecipes,
                           withJsonDecoder: nil) { (result: Result<[Recipe], Error>) in
            switch result {
            case .failure (let error):
                XCTFail ("Model retrieval failed: \(String(describing: error))")
            case .success:
                XCTAssert (self.cacheMock.didQuery)
                XCTAssert (self.cacheMock.didStore)
            }
        }
    }
    
    func testFailingModelRequests() {
        // test JSON decoding error propagation
        networkFetcherMock.handler = { url in
            return .success ("garbage".data (using: .utf8)!)
        }
        sut.retrieveModel (from: URL (string: "http://random")!,
                           withJsonDecoder: nil) { (result: Result<[Recipe], Error>) in
            switch result {
            case .success (let value):
                XCTFail ("Got model when there shouldn't have been one: \(value)")
            case .failure:
                XCTAssert (self.cacheMock.didQuery)
                XCTAssertFalse (self.cacheMock.didStore)
            }
        }
    }
    
    func testNotFoundCaching() {
        // test caching of 404s
        networkFetcherMock.handler = { url in
            return .failure (NetworkFetcherError.incorrectStatusCode (statusCode: 404))
        }
        sut.makeRequest(to: APIEndpoint.getRecipes) { (result: Result<Data, Error>) in
            switch result {
            case .success (let value):
                XCTFail ("Got model when there shouldn't have been one: \(value)")
            case .failure:
                XCTAssert (self.cacheMock.didQuery)
                XCTAssert (self.cacheMock.didStore)
            }
        }
    }
    
    class FakeNetworkFetcher: NetworkFetcher {
        var handler: ((URL) -> Result<Data, Error>)?
        
        func request (to url: URLRequestConvertible,
                      completion: @escaping ((Result<Data, Error>) -> Void)) {
            if let handler = self.handler {
                completion (handler (url.url!))
            }
        }
    }
}
