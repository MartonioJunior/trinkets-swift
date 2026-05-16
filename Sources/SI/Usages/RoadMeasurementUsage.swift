//
//  RoadMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// Usage of length measurement related to a road.
/// 
/// Length is displayed in meters and kilometers, depending on the value.
/// 
/// Any decimal values are rounded.
public struct RoadMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral>
where Value.FloatLiteralType == Double {}

// MARK: Self: MeasurementUsage
extension RoadMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Length, Value>) -> Tagged<PrefixedUnit<Kilo, Length.Meters>, Value> {
        .init(baseValue.converted(to: .kilo, .meters).rawValue.rounded())
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents length related to a road.
    static func road<Value>() -> Self
    where Self == RoadMeasurementUsage<Value> { .init() }
}
