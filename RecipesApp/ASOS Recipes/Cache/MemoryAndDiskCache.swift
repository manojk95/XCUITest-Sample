//
//  MemoryAndDiskCache.swift
//  ASOS Recipes
//

import Foundation

/// A cache which combines both `memory` and `disk` caches.
final class MemoryAndDiskCache: Cache {
    let cachingPolicy: CachingPolicy
    
    private let memoryCache: MemoryCache
    private let diskCache: DiskCache
    
    /// Initializes a new instance of a combined disk and memory cache.
    ///
    /// - Parameters:
    ///   - policy: The caching policy, shared across the two caches.
    ///   - namespace: The caching namespace used for the disk cache. Must be a valid folder name.
    /// - Throws: Errors raised during `DiskCache` initialization.
    init (policy: CachingPolicy, namespace: String) throws {
        self.cachingPolicy = policy
        self.memoryCache = MemoryCache (policy: policy)
        self.diskCache = try DiskCache (policy: policy, namespace: namespace)
    }
    
    func store (key: String, data: Data, completion: @escaping ((CachingError?) -> ())) {
        self.memoryCache.store (key: key, data: data) { error in
            if let error = error {
                return completion (error)
            }
            self.diskCache.store (key: key, data: data, completion: completion)
        }
    }
    
    func retrieve (key: String, completion: @escaping ((Result<Data, CachingError>) -> ())) {
        // Try to retrieve from memory first.
        self.memoryCache.retrieve (key: key) { memoryCacheResult in
            switch memoryCacheResult {
            case .failure(.keyNotFound), .failure(.keyExpired):
                // If nothing is found from memory, try to fetch data from disk.
                self.diskCache.retrieve (key: key) { diskCacheResult in
                    if case .success (let data) = diskCacheResult {
                        // If we got data from the disk cache, save it in the memory cache too.
                        self.memoryCache.store (key: key, data: data) { _ in }
                    }
                    // Propagate the result.
                    return completion (diskCacheResult)
                }
            case .failure, .success:
                // Just propagate the result otherwise.
                return completion (memoryCacheResult)
            }
        }
    }
}
