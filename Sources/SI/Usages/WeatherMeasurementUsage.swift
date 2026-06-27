//
//  WeatherMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// An usage of a temperature measurement related to the weather.
/// 
/// Temperature is displayed in celsius.
public struct WeatherMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral> {}

// MARK: Self: MeasurementUsage
extension WeatherMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Energy, Value>) -> Tagged<Energy.Calories, Value> {
        baseValue.calories
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents energy for a given weather temperature.
    static func weather<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self
    where Self == WeatherMeasurementUsage<Value> { .init() }
}
