//
//  PersonTemperatureMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// An usage of a temperature as it relates to people.
/// 
/// Temperature is displayed in celsius.
public struct PersonTemperatureMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral> {}

// MARK: Self: MeasurementUsage
extension PersonTemperatureMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Energy, Value>) -> Tagged<Energy.Calories, Value> {
        baseValue.calories
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents energy for a given person temperature.
    static func personTemperature<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self 
    where Self == PersonTemperatureMeasurementUsage<Value> { .init() }
}
