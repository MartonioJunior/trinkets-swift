//
//  FoodMeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged
import TrinketsUnits

/// An usage of an energy measurement related to food.
/// 
/// Energy gained is displayed in calories.
public struct FoodMeasurementUsage<Value: FloatingPoint & ExpressibleByFloatLiteral> {}

// MARK: Self: MeasurementUsage
extension FoodMeasurementUsage: MeasurementUsage {
    // swiftlint:disable:next missing_docs
    public func measure(for baseValue: Tagged<Energy, Value>) -> Tagged<Energy.Calories, Value> {
        baseValue.converted(to: \.calories)
    }
}

// MARK: MeasurementUsage (EX)
public extension MeasurementUsage {
    /// Measure represents energy for a given food.
    static func food<Value: FloatingPoint & ExpressibleByFloatLiteral>() -> Self
    where Self == FoodMeasurementUsage<Value> { .init() }
}
