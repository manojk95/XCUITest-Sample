//
//  NetworkFetcher.swift
//  ASOS Recipes
//

import Foundation

/// Generic protocol for an object responsible for fetching data from the network.
protocol NetworkFetcher {
    /// Performs an HTTP requst using the `URLRequest` specified by `url` and returns the result
    /// in the passed completion.
    ///
    /// - Parameters:
    ///   - url: The target endpoint.
    ///   - completion: Completion to which a `Result<Data, Error>` object is passed.
    func request (
        to url: URLRequestConvertible,
        completion: @escaping ((Result<Data, Error>) -> Void)
    )
}

enum NetworkFetcherError: Swift.Error {
    case noDataInResponse, incorrectStatusCode (statusCode: Int)
}
