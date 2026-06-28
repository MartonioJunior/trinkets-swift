//
//  Quantifiable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 31/08/2025.
//

/// Unit or quantifiable aspect that can be used for comparison purposes.
/// 
/// Works a marker protocol that transforms any type into a valid unit of measure.
/// 
/// Any conforming types can create the following unit types:
/// - Static units, by using the type as the marker for the unit.
/// - Dynamic units, using the instance as the unit.
/// 
/// If you want to create a static unit only, conform the type to `StaticUnit` instead
/// and declare it as a non-instantiable type.
public protocol Quantifiable {}

// MARK: Default Implementation
public extension Quantifiable {
    /// Creates a new measurement.
    /// - Parameter value: Quantity associated with the aspect.
    /// - Returns: A new measurement.
    /// 
    /// Example:
    /// ```swift
    /// let fiveStrawberries = strawberries.x(5)
    /// ```
    @inlinable
    func x<Value>(_ value: Value) -> Measurement<Self, Value> {
        .init(value, self)
    }
    /// Creates a new measure by combining unit and quantity.
    /// - Parameters:
    ///   - lhs: Unit used as the base.
    ///   - rhs: Quantity for the unit.
    ///
    /// - Returns: A new measurement.
    /// 
    /// Example:
    /// ```swift
    /// let sixOranges = oranges * 6
    /// ```
    @inlinable
    static func * <Value>(lhs: Self, rhs: Value) -> Measurement<Self, Value> {
        lhs.x(rhs)
    }
    /// Creates a new measure by combining unit and quantity.
    /// - Parameters:
    ///   - lhs: Quantity for the unit.
    ///   - rhs: Unit used as the base.
    ///
    /// - Returns: A new measurement.
    /// 
    /// Example:
    /// ```swift
    /// let nineApples = 9 * apples
    /// ```
    @inlinable
    static func * <Value>(lhs: Value, rhs: Self) -> Measurement<Self, Value> {
        rhs.x(lhs)
    }
    /// Creates a new function that evaluates an object to obtain a measure.
    /// - Parameters:
    ///   - unit: Unit defined for the measure.
    ///   - value: Quantity extracted by the value.
    ///
    /// - Returns: A function that receives an object and returns it's measurement.
    static func measure<T, Value>(
        _: T.Type = T.self,
        in unit: Self,
        f value: @escaping (T) -> Value
    ) -> (T) -> Measurement<Self, Value> {
        { unit.x(value($0)) }
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Quantifiable {
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
