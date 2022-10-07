//
//  APIEndpoint.swift
//  ASOS Recipes
//

import Foundation

enum APIEndpoint: URLRequestConvertible {
    /// Fetches the list of recipes and their associated information & image URLs.
    case getRecipes
    
    /// The base API url.
    private static let API_BASE_URL = URL (
        string: "https://mobile.asosservices.com/sampleapifortest/"
    )!
    
    /// The path of this endpoint.
    var path: String {
        switch self {
        case .getRecipes:
            return "recipes.json"
        }
    }
    
    /// The full URL of this endpoint.
    var url: URL? {
        return URL (string: self.path, relativeTo: APIEndpoint.API_BASE_URL)
    }
    
    /// Converts this `APIEndpoint` to an `URLRequest`.
    func toURLRequest() -> URLRequest {
        guard let url = self.url else {
            fatalError ("URL for APIEndpoint \(self) couldn't be parsed!")
        }
        let urlRequest = URLRequest (url: url)
        // nothing to do here since this is just a simple API
        return urlRequest
    }
}
