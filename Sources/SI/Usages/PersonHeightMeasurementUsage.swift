//
//  PersonHeightMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage of a length measurement related to a person's height.
/// 
/// Length is displayed in centimeters.
public struct PersonHeightMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension PersonHeightMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Length, Value>) -> Tagged<PrefixedUnit<Centi, Length.Meters>, Value> {
        baseValue.converted(to: .centi, .meters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents length related to a person's height.
    static func personHeight<Value>() -> Self
    where Self == PersonHeightMeasurementUsage<Value> { .init() }
}
