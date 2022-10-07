//
//  DiskCache.swift
//  ASOS Recipes
//

import Foundation

/// This cache stores objects on disk using an user-defined namespace and expiration options.
class DiskCache: Cache {
    /// Caching policy of this cache.
    let cachingPolicy: CachingPolicy
    
    /// The filesystem path of this cache.
    let cacheUrl: URL
    
    /// The file manager responsible for file operations of this cache.
    let fileManager: FileManager
    
    // MARK: Init
    /// Creates a new instance of a disk cache.
    ///
    /// - Parameters:
    ///   - policy: The caching policy.
    ///   - namespace: The filesystem namespace used by this cache. Must be a valid folder name.
    ///   - fileManager: The file manager used for file operations by this cache.
    /// - Throws: Exceptions raised by `FileManager` during file operations.
    init (policy: CachingPolicy, namespace: String, fileManager: FileManager = .default) throws {
        self.cachingPolicy = policy
        // First, retrieve the directory specified by the `FileManager` for caching.
        var cacheUrl = try fileManager.url (
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        // Append the specified namespace.
        cacheUrl.appendPathComponent (namespace, isDirectory: true)
        // Create the directory if it doesn't exist.
        try fileManager.createDirectory (
            at: cacheUrl,
            withIntermediateDirectories: true,
            attributes: nil
        )
        // Initialization is complete -- save the URL.
        self.cacheUrl = cacheUrl
        self.fileManager = fileManager
    }
    
    // MARK: Cache
    func store (key: String, data: Data, completion: @escaping ((CachingError?) -> ())) {
        // Perform all potentially long tasks in a different queue.
        let destinationUrl = self.url (forKey: key)
        DispatchQueue.global (qos: .utility).async {
            let path = destinationUrl.path
            self.fileManager.createFile (
                atPath: path,
                contents: data,
                attributes: nil
            )
            // To store expiration dates, use a neat trick: just put the expiration date
            // as the "modificationDate" attribute of the file.
            // Thanks to hyperoslo/Cache for inspiration.
            switch self.cachingPolicy {
            case .expires (let afterTimeInterval):
                do {
                    try self.fileManager.setAttributes ([
                        .modificationDate: Date().addingTimeInterval (afterTimeInterval)
                    ], ofItemAtPath: path)
                } catch let error {
                    return completion (.other (error: error))
                }
            }
            completion (nil)
        }
    }
    
    func retrieve (key: String, completion: @escaping ((Result<Data, CachingError>) -> ())) {
        let sourceUrl = self.url (forKey: key)
        // Check if the specified key exists, otherwise short circuit immediately.
        guard (try? sourceUrl.checkResourceIsReachable()) ?? false else {
            return completion (.failure (.keyNotFound))
        }
        DispatchQueue.global (qos: .utility).async {
            do {
                // Read the file.
                let data = try Data (contentsOf: sourceUrl)
                // Check the expiration using the trick described before.
                let attributes = try self.fileManager.attributesOfItem (atPath: sourceUrl.path)
                // First, ensure that we can retrieve a valid date.
                guard let expirationDate = attributes[.modificationDate] as? Date else {
                    return completion (.failure (.other (error: Error.invalidFileAttributes)))
                }
                // Then, check the effective expiration time.
                guard expirationDate.timeIntervalSinceNow > 0 else {
                    // Key expired. Remove from the filesystem.
                    try self.fileManager.removeItem (at: sourceUrl)
                    return completion (.failure (.keyExpired))
                }
                // All done!
                completion (.success (data))
            } catch let error {
                return completion (.failure (.other (error: error)))
            }
        }
    }
    
    // MARK: Utilities
    /// Encodes the given key and makes it safe to use for filesystem names.
    private func encodeKey (_ key: String) -> String {
        // A simple way to encode the key without involving crypto is just to encode it in
        // base64url, a subset of base64 which substitutes URL/filename-unsafe characters with
        // safe ones.
        return Data (key.utf8).base64EncodedString()
            .replacingOccurrences (of: "+", with: "-")
            .replacingOccurrences (of: "/", with: "_")
            .replacingOccurrences (of: "=", with: "")
    }
    
    /// Retrieves the fully qualified filesystem URL for the given key.
    private func url (forKey key: String) -> URL {
        return self.cacheUrl.appendingPathComponent (self.encodeKey (key))
    }
    
    enum Error: Swift.Error {
        case invalidFileAttributes
    }
}
