//
//  URLSession+NetworkFetcher.swift
//  ASOS Recipes
//

import Foundation

/// Implementation of `NetworkFetcher` for `URLSession`.
extension URLSession: NetworkFetcher {
    func request (to url: URLRequestConvertible,
                  completion: @escaping ((Result<Data, Swift.Error>) -> Void)) {
        self.dataTask (with: url.toURLRequest()) { data, response, error in
            // Check errors and propagate them.
            if let error = error {
                return completion (.failure (error))
            }
            // Check status codes.
            if let response = response as? HTTPURLResponse,
                !(200...299).contains (response.statusCode) {
                return completion (.failure (NetworkFetcherError.incorrectStatusCode (
                    statusCode: response.statusCode)))
            }
            // Raise an error if we received no data.
            guard let data = data else {
                return completion (.failure (NetworkFetcherError.noDataInResponse))
            }
            // All done.
            completion (.success (data))
        }.resume()
    }
}
