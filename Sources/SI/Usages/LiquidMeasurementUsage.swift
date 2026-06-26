//
//  LiquidMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Measurement usage to format the amount of liquid.
/// 
/// Volume is displayed in liters (or it's prefixed versions).
public struct LiquidMeasurementUsage<Value: FloatingPoint> {}

// MARK: Self: MeasurementUsage
extension LiquidMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Volume, Value>) -> Tagged<Volume.Liters, Value> {
        baseValue.converted(to: \.liters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents wind speed.
    static func liquid<Value: FloatingPoint>() -> Self
    where Self == LiquidMeasurementUsage<Value> { .init() }
}
