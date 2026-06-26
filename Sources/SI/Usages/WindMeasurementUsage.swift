//
//  WindMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Measurement usage that describes the unit for wind speed.
/// 
/// Speed is displayed in kilometers per hour.
public struct WindMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral> {}

// MARK: Self: MeasurementUsage
extension WindMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Speed, Value>) -> Tagged<Speed.KilometersPerHour, Value> {
        baseValue.converted(to: \.kilometersPerHour)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents wind speed.
    static func wind<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self 
    where Self == WindMeasurementUsage<Value> { .init() }
}
