//
//  FromIndexPath.swift
//  ASOS Recipes
//

import Foundation

/// Provides the possibility of instantiating a member of this enumeration from an IndexPath,
/// assuming that members' raw values represent IndexPath sections.
protocol FromIndexPath: RawRepresentable where RawValue == Int {
    /// Instantiates a member of this enumeration given an `IndexPath`.
    ///
    /// - Parameter indexPath: The IndexPath whose section will be used as a `rawValue`.
    /// - Returns: The member of this enumeration with the corresponding `rawValue`.
    static func from (indexPath: IndexPath) -> Self
    
    /// Instantiates a member of this enumeration given a section number.
    ///
    /// - Parameter sectionNumber: The section number that will be used as a `rawValue`.
    /// - Returns: The member of this enumeration with the corresponding `rawValue`.
    static func from (sectionNumber: Int) -> Self
}

extension FromIndexPath {
    static func from (sectionNumber: Int) -> Self {
        if let value = Self (rawValue: sectionNumber) {
            return value
        }
        fatalError ("Unknown section number passed to \(Self.self): \(sectionNumber)")
    }
    
    static func from (indexPath: IndexPath) -> Self {
        return Self.from (sectionNumber: indexPath.section)
    }
}
