//
//  URLRequestConvertible.swift
//  ASOS Recipes
//

import Foundation

/// A protocol which defines a value that can be transformed to an `URLRequest` and optionally
/// provides an `URL` parameter.
protocol URLRequestConvertible {
    /// The url represented by this object.
    var url: URL? { get }
    
    /// Transforms this object to an `URLRequest`.
    func toURLRequest() -> URLRequest
}

// Default implementations for `URLRequest` and `URL`.
extension URLRequest: URLRequestConvertible {
    func toURLRequest() -> URLRequest {
        return self
    }
}

extension URL: URLRequestConvertible {
    var url: URL? {
        return self
    }
    
    func toURLRequest() -> URLRequest {
        return URLRequest (url: self)
    }
}
