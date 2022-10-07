//
//  TimeInterval+Format.swift
//  ASOS Recipes
//

import Foundation

extension TimeInterval {
    /// Formats this `TimeInterval` with a specified unit style and max unit number.
    func format (
        withUnitsStyle unitsStyle: DateComponentsFormatter.UnitsStyle,
        maxUnits: Int = 0
    ) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = unitsStyle
        formatter.maximumUnitCount = maxUnits
        return formatter.string (from: self)
    }
}
