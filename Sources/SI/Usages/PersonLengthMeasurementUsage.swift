//
//  PersonLengthMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage of a length measurement for distances as it relates to people.
/// 
/// Length is displayed in centimeters.
public struct PersonLengthMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension PersonLengthMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Length, Value>) -> Tagged<PrefixedUnit<Centi, Length.Meters>, Value> {
        baseValue.converted(to: .centi, .meters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents length for distance as it relates to people.
    static func personLength<Value>() -> Self
    where Self == PersonLengthMeasurementUsage<Value> { .init() }
}
