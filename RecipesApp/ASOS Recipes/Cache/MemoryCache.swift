//
//  MemoryCache.swift
//  ASOS Recipes
//

import Foundation

/// This cache stores objects in memory with a given expiration using an `NSCache`.
class MemoryCache: Cache {
    // MARK: Entry
    /// This is used to internally represent entries inside the `NSCache`. Note that this is
    /// not a value type because `NSCache` requires entries to be as such.
    private final class Entry {
        /// This entry's expiration date. If `nil`, this entry does not expire.
        let expiration: Date?
        
        /// This entry's data.
        let data: Data
        
        /// Whether this entry is expired or not.
        var isExpired: Bool {
            guard let expiration = self.expiration else {
                return false
            }
            return expiration.timeIntervalSinceNow < 0
        }
        
        /// Creates a new `Entry` with a given expiration date and data.
        init (expiration: Date?, data: Data) {
            self.expiration = expiration
            self.data = data
        }
        
        /// Creates a new `Entry` with a given caching policy and data.
        convenience init (policy: CachingPolicy, data: Data) {
            switch policy {
            case .expires(let afterTimeInterval):
                self.init (expiration: Date().addingTimeInterval (afterTimeInterval), data: data)
            }
        }
    }
    
    /// The backing store.
    private lazy var cache = NSCache<NSString, Entry>()
    
    /// Caching policy of this cache.
    let cachingPolicy: CachingPolicy
    
    // MARK: Init
    /// Initializes this cache with the given `CachingPolicy`.
    init (policy: CachingPolicy) {
        self.cachingPolicy = policy
    }
    
    func store (key: String, data: Data, completion: (CachingError?) -> ()) {
        let entry = Entry (policy: self.cachingPolicy, data: data)
        self.cache.setObject (entry, forKey: NSString (string: key))
        completion (nil)
    }
    
    func retrieve (key: String, completion: (Result<Data, CachingError>) -> ()) {
        // Retrieve the entry, if available.
        let key = NSString (string: key)
        if let entry = self.cache.object (forKey: key) {
            // Check the expiration before proceeding.
            guard !entry.isExpired else {
                // remove entry
                self.cache.removeObject (forKey: key)
                return completion (.failure (.keyExpired))
            }
            // All done!
            completion (.success (entry.data))
        } else {
            completion (.failure (.keyNotFound))
        }
    }
}
