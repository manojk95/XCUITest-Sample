//
//  CacheMock.swift
//  ASOS RecipesTests
//

import Foundation
@testable import ASOS_Recipes

class CacheMock: Cache {
    var didQuery = false
    var didStore = false
    
    var cachingPolicy: CachingPolicy {
        return .expires (after: 0)
    }
    
    func store (key: String, data: Data, completion: @escaping ((CachingError?) -> ())) {
        didStore = true
        completion (nil)
    }
    
    func retrieve (key: String, completion: @escaping ((Result<Data, CachingError>) -> ())) {
        didQuery = true
        completion (.failure (.keyNotFound))
    }
}
