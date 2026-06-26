//
//  BarometricMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// An usage of a pressure measurement for barometric pressure.
/// 
/// Pressure is displayed in millibars.
public struct BarometricMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension BarometricMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(
        for baseValue: Tagged<Pressure, Value>
    ) -> Tagged<PrefixedUnit<Milli, Pressure.Bars>, Value> {
        baseValue.converted(to: .milli, \.bars)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents pressure for barometric pressure.
    static func barometric<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self
    where Self == BarometricMeasurementUsage<Value> { .init() }
}
