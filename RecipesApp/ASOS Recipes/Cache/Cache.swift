//
//  Cache.swift
//  ASOS Recipes
//

import Foundation

enum CachingPolicy {
    /// Caching policy which assigns an expiration time to each object inside it.
    case expires (after: TimeInterval)
}

enum CachingError: Error {
    case keyNotFound, keyExpired
    case other (error: Error)
    
    var isDueToMissingKey: Bool {
        switch self {
        case .keyNotFound, .keyExpired:
            return true
        default:
            return false
        }
    }
}

/// A generic, multi-purpose cache implementation with support for expiration of items.
protocol Cache {
    /// The caching policy associated to this cache object.
    var cachingPolicy: CachingPolicy { get }
    
    /// Stores a data object in the cache.
    ///
    /// - Parameters:
    ///   - key: The key associated to this object.
    ///   - data: The data object.
    ///   - completion: Completion closure with which it's possible to obtain any errors.
    func store (key: String, data: Data, completion: @escaping ((CachingError?) -> ()))
    
    
    /// Tries to retrieve an object from the cache.
    ///
    /// - Parameters:
    ///   - key: The key to be looked up in the cache.
    ///   - completion: Completion closure to which a `Result` object is passed, containing
    ///                 either the `Data` associated to the found object, or a `CachingError`.
    func retrieve (key: String, completion: @escaping ((Result<Data, CachingError>) -> ()))
}
