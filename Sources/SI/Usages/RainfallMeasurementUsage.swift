//
//  RainfallMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage of a length measure to format the rainfall amount.
/// 
/// Length is displayed in centimeters.
public struct RainfallMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension RainfallMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Length, Value>) -> Tagged<PrefixedUnit<Centi, Length.Meters>, Value> {
        baseValue.converted(to: .centi, .meters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents length for amount of rainfall.
    static func rainfall<Value>() -> Self
    where Self == RainfallMeasurementUsage<Value> { .init() }
}
