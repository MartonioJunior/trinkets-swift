//
//  SnowfallMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage of a length measure for snowfall amount.
/// 
/// Length is displayed in centimeters.
public struct SnowfallMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension SnowfallMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(
        for baseValue: Tagged<Length, Value>
    ) -> Tagged<PrefixedUnit<Centi, Length.Meters>, Value> {
        baseValue.converted(to: .centi, .meters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents length for snowfall amount.
    static func snowfall<Value>() -> Self
    where Self == SnowfallMeasurementUsage<Value> { .init() }
}
