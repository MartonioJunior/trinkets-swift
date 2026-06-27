//
//  PersonWeightMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// An usage of a mass measurement related to a person's weight.
/// 
/// Mass is displayed in grams or kilograms, depending on the base value.
public struct PersonWeightMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral> {}

// MARK: Self: MeasurementUsage
extension PersonWeightMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Energy, Value>) -> Tagged<Energy.Calories, Value> {
        baseValue.calories
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents mass for a given person's weight.
    static func personWeight<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self
    where Self == PersonWeightMeasurementUsage<Value> { .init() }
}
