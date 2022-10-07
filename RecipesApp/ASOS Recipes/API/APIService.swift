//
//  APIService.swift
//  ASOS Recipes
//

import Foundation

protocol APIServiceProtocol {
    /// Retrieves a `Decodable` model from the network.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to use. See also `APIEndpoint`.
    ///   - jsonDecoder: The `JSONDecoder` object to use to decode the response. A default instance
    ///                  is created if `nil`.
    ///   - completion: Completion closure to which a Result containing the decoded model or an
    ///                error is passed.
    func retrieveModel<T: Decodable>(
        from endpoint: URLRequestConvertible,
        withJsonDecoder jsonDecoder: JSONDecoder?,
        completion: @escaping ((Result<T, Error>) -> Void)
    )
    
    /// Performs a generic network request.
    ///
    /// - Parameters:
    ///   - endpoint: The target endpoint.
    ///   - completion: Completion closure to which a Result containing the received data or an
    ///                 error is passed.
    func makeRequest (
        to endpoint: URLRequestConvertible,
        completion: @escaping ((Result<Data, Error>) -> Void)
    )
}

/// Specialized instance of `APIServiceProtocol` which also uses a cache to cache the responses.
class CachedAPIService: APIServiceProtocol {
    let networkFetcher: NetworkFetcher
    let cache: Cache
    
    init (cache: Cache, networkFetcher: NetworkFetcher) {
        self.networkFetcher = networkFetcher
        self.cache = cache
    }
    
    func retrieveModel<T: Decodable>(
        from endpoint: URLRequestConvertible,
        withJsonDecoder jsonDecoder: JSONDecoder?,
        completion: @escaping ((Result<T, Swift.Error>) -> Void)
    ) {
        self.performCachedRequest (
            to: endpoint,
            transform: { data in
                return self.decodeModel (withJsonDecoder: jsonDecoder, data: data)
            },
            completion: completion
        )
    }
    
    func makeRequest (
        to endpoint: URLRequestConvertible,
        completion: @escaping ((Result<Data, Swift.Error>) -> Void)
    ) {
        self.performCachedRequest (
            to: endpoint,
            transform: { .success ($0) },
            completion: completion
        )
    }
    
    // MARK: Private API
    
    /// Decodes a `Data` object to the specified `Decodable` instance using the passed
    /// `JSONDecoder` instance or a new one.
    ///
    /// - Parameters:
    ///   - jsonDecoder: The `JSONDecoder` to use. If `nil` a new one is instantiated.
    ///   - data: The data to decode.
    /// - Returns: Either the parsed and decoded model, or an error.
    private func decodeModel<T: Decodable>(
        withJsonDecoder jsonDecoder: JSONDecoder?,
        data: Data
    ) -> Result<T, Swift.Error> {
        do {
            let jsonDecoder = jsonDecoder ?? JSONDecoder()
            return .success (try jsonDecoder.decode (T.self, from: data))
        } catch let error {
            return .failure (error)
        }
    }
    
    /// Performs an HTTP request, storing responses in the supplied cache and with the possibility
    /// to transform incoming data objects to avoid caching of invalid values.
    ///
    /// - Parameters:
    ///   - endpoint: The target HTTP endpoint.
    ///   - transform: A transformation closure – only called in case of successful requests –
    ///                to which a `Data` object is supplied and which returns a transformed type
    ///                based on that `Data` object. If the transform fails, no caching is
    ///                performed. Note that it's perfectly fine to supply an identity transform.
    ///   - completion: The completion closure to which the transformed data is passed, or an
    ///                 error.
    private func performCachedRequest<T>(
        to endpoint: URLRequestConvertible,
        transform: @escaping (Data) -> Result<T, Swift.Error>,
        completion: @escaping (Result<T, Swift.Error>) -> Void
    ) {
        guard let url = endpoint.url else {
            fatalError ("Invalid endpoint \(endpoint) given to APIService")
        }
        // Check if this request is in cache.
        return self.cache.retrieve (key: url.absoluteString) { result in
            switch result {
            case .success (let data):
                completion (transform (data))
            case .failure:
                // Cache miss. Perform a network request.
                self.networkFetcher.request (to: endpoint) { result in
                    switch result {
                    case .failure (NetworkFetcherError.incorrectStatusCode (let code))
                        where code == 404:
                        // Short circuit: if receiving a 404, cache bogus data to avoid continuos
                        // network requests. This will shift errors after the initial failed
                        // request from "404" to a decoding failure, but for this purpose that's
                        // an acceptable compromise.
                        let bogusData = Data()
                        self.cache.store (key: url.absoluteString, data: bogusData) { cacheError in
                            if let cacheError = cacheError {
                                // Caching storage errors are not really relevant, but
                                // we log them nonetheless to not forget about them.
                                debugPrint ("Received cache store error: ", cacheError)
                            }
                        }
                        completion (.failure (
                            NetworkFetcherError.incorrectStatusCode (statusCode: code)
                        ))
                    case .failure (let error):
                        // Propagate other errors.
                        return completion (.failure (error))
                    case .success (let data):
                        // Transform the data.
                        let transformedData = transform (data)
                        // Only cache successful transforms.
                        if case .success = transformedData {
                            self.cache.store (key: url.absoluteString, data: data) { cacheError in
                                if let cacheError = cacheError {
                                    // Caching storage errors are not really relevant, but
                                    // we log them nonetheless to not forget about them.
                                    debugPrint ("Received cache store error: ", cacheError)
                                }
                            }
                        }
                        completion (transformedData)
                    }
                }
            }
        }
    }
}
