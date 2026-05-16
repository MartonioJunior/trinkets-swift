//
//  MeasurementUsage.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged

/// Measure modifier that is applied to a given base value.
/// 
/// This is achieved by converting the base value to use the most appropriate unit.
/// 
/// Use this approach when you want to display information about a measure
/// that aligns with a given use case.
public protocol MeasurementUsage<D, Value> {
    /// Domain where the target unit exists.
    associatedtype D: Domain
    /// Most appropriate type of measure for this use case.
    associatedtype Output
    /// Quantity associated with the unit.
    associatedtype Value
    // MARK: Methods
    /// Creates a measurement for a given value type.
    /// - Parameter baseValue: Base value for the operation.
    /// - Returns: A new measurement with the most appropriate use case.
    func measure(for baseValue: Tagged<D, Value>) -> Output
}
