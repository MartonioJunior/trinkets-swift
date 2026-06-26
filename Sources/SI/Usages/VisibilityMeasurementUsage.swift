//
//  VisibilityMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage of a length measure to describe the distance of visibility.
/// 
/// Length is measured in meters.
public struct VisibilityMeasurementUsage<Value: Numeric> {}

// MARK: Self: MeasurementUsage
extension VisibilityMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Length, Value>) -> Tagged<Length.Meters, Value> {
        baseValue.converted(to: \.meters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents length for visibility.
    static func visibility<Value: Numeric>() -> Self
    where Self == VisibilityMeasurementUsage<Value> { .init() }
}
