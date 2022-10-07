//
//  Coordinator.swift
//  ASOS Recipes
//

import Foundation

/// Represents a `Coordinator`, the object responsible for this app's navigation flow.
protocol Coordinator: AnyObject {
    /// Starts the main flow of this coordinator.
    func start()
}

/// Protocol that signals an object that returns a value on completion.
protocol ReturnsValueOnCompletion {
    associatedtype ValueType
    
    var onComplete: ((ValueType) -> ())? { get }
}
