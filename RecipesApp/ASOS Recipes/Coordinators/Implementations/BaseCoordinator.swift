//
//  BaseCoordinator.swift
//  ASOS Recipes
//

import Foundation

/// The father of all coordinators -- contains logic about adding child coordinators.
class BaseCoordinator: Coordinator {
    var children: [Coordinator] = []
    
    func start() {
        fatalError ("start() in BaseCoordinator must be implemented in subclass")
    }
    
    /// Adds a child coordinator.
    func addChild (_ coordinator: Coordinator) {
        guard !(children.contains { $0 === coordinator }) else {
            return
        }
        self.children.append (coordinator)
    }
    
    /// Removes a children coordinator.
    func removeChild (_ coordinator: Coordinator?) {
        guard
            let coordinator = coordinator,
            let firstIndex = (self.children.firstIndex { $0 === coordinator })
            else { return }
        self.children.remove (at: firstIndex)
    }
}
