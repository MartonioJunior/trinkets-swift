//
//  StaticQuantifiable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/06/2026.
//

import Tagged

/// Unit or quantifiable type that can be used for comparison purposes.
/// 
/// This protocol expands upon `Quantifiable` acts as the basis for dimension and static measures
/// using the type as the unit definition.
/// 
/// You can use this to create hybrid measurement models where dynamic units exist in a domain represented by the type itself.
/// 
/// To maintain the definition at compile-time only, define you desired aspect as an enum of no values or as a single value struct.
public protocol StaticQuantifiable: Quantifiable {}

// MARK: Default Implementation
public extension StaticQuantifiable {
    /// Creates a new static measurement.
    /// - Parameter value: Quantity associated with the aspect.
    /// - Returns: A new tagged value.
    @inlinable
    static func x<Value>(_ value: Value) -> Tagged<Self, Value> {
        .init(value)
    }
    /// Creates a new static measure by combining unit type and quantity.
    /// - Parameters:
    ///   - rhs: Quantity for the unit.
    ///
    /// - Returns: A new tagged value.
    /// 
    /// Example:
    /// ```swift
    /// let twoPineapples = Pineapple.x(2)
    /// ```
    @inlinable
    static func * <Value>(_: Self.Type, rhs: Value) -> Tagged<Self, Value> {
        .init(rhs)
    }
    /// Creates a new static measure by combining unit type and quantity.
    /// - Parameters:
    ///   - lhs: Quantity for the unit.
    ///
    /// - Returns: A new tagged value.
    /// 
    /// Example:
    /// ```swift
    /// let eightGrapes = 8 * Grapes.self
    /// ```
    @inlinable
    static func * <Value>(lhs: Value, _: Self.Type) -> Tagged<Self, Value> {
        .init(lhs)
    }
    /// Creates a new function that evaluates an object to obtain a static measure.
    /// - Parameters:
    ///   - unit: Unit defined for the measure.
    ///   - value: Quantity extracted by the value.
    ///
    /// - Returns: A function that receives an object and returns it's measurement.
    static func measure<T, Value>(
        _: T.Type = T.self,
        f value: @escaping (T) -> Value
    ) -> (T) -> Tagged<Self, Value> {
        { .init(value($0)) }
    }
}
