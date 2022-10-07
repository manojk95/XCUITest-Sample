//
//  APIServiceMock.swift
//  ASOS RecipesTests
//

import Foundation
@testable import ASOS_Recipes

struct APIServiceMock: APIServiceProtocol {
    private var staticData: [URL: String]?
    private var failure: Error?
    
    var onRequest: ((URL) -> Void)?
    
    init() {}
    
    init (staticData: [URL: String]?) {
        self.staticData = staticData
    }
    
    init (staticData: [APIEndpoint: String]) {
        self.staticData = Dictionary (
            uniqueKeysWithValues: staticData.map { key, value in
                (key.url!, value)
            }
        )
    }
    
    init (withFailureKind failure: Error) {
        self.failure = failure
    }
    
    func retrieveModel<T: Decodable>(from endpoint: URLRequestConvertible,
                          withJsonDecoder jsonDecoder: JSONDecoder?,
                          completion: @escaping ((Result<T, Error>) -> Void)) {
        self.onRequest?(endpoint.url!)
        if let failure = self.failure {
            return completion (.failure (failure))
        }
        if let staticData = self.staticData, let response = staticData[endpoint.url!] {
            let decoder = jsonDecoder ?? JSONDecoder()
            do {
                completion (.success (
                    try decoder.decode (T.self, from: response.data (using: .utf8)!
                )))
            } catch let error {
                completion (.failure (error))
            }
            return
        }
        completion (.failure (NetworkFetcherError.incorrectStatusCode (statusCode: 404)))
    }
    func makeRequest(to endpoint: URLRequestConvertible,
                     completion: @escaping ((Result<Data, Error>) -> Void)) {
        self.onRequest?(endpoint.url!)
        if let failure = self.failure {
            return completion (.failure (failure))
        }
        completion (.failure (NetworkFetcherError.incorrectStatusCode (statusCode: 404)))
    }
}
