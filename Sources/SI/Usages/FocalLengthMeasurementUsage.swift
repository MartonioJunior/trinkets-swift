//
//  FocalLengthMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage for a length measurement for formatting the focal length of 
/// an optical system (e.g. camera lenses)
/// 
/// Length is displayed in millimeters.
public struct FocalLengthMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension FocalLengthMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Length, Value>) -> Tagged<PrefixedUnit<Milli, Length.Meters>, Value> {
        baseValue.converted(to: .milli, .meters)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents focal length of optical systems.
    static func focalLength<Value>() -> Self
    where Self == FocalLengthMeasurementUsage<Value> { .init() }
}
