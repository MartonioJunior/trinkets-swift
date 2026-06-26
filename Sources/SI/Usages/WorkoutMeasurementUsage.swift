//
//  WorkoutMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// An usage of an energy measurement related to a workout.
/// 
/// Energy spent is displayed in calories.
public struct WorkoutMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral> {}

// MARK: Self: MeasurementUsage
extension WorkoutMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Energy, Value>) -> Tagged<Energy.Calories, Value> {
        baseValue.converted(to: \.calories)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents energy for a given workout.
    static func workout<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self
    where Self == WorkoutMeasurementUsage<Value> { .init() }
}
