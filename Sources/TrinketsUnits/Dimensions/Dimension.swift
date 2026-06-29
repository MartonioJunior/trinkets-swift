//
//  Dimension.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Foundation

/// Domain that defines a common base value for a set of units.
public protocol Dimension: Domain, StaticQuantifiable {
    /// Type representing the base unit of the conversion system
    associatedtype BaseUnit: Convertible where BaseUnit.Base == Self
    /// Correlation exponents in relation to other dimensions.
    static var dimensionality: Dimensionality { get }
}

// MARK: Default Implementation
public extension Dimension {
    // swiftlint:disable:next missing_docs
    static var dimensionality: Dimensionality { [Self.self: 1] }
    /// Unit from the dimension to be used.
    /// - Parameter unit: Unit to be used.
    /// - Returns: `unit`.
    /// 
    /// Works as an easy DotSyntax accessor for the dynamic units of a given dimension:
    /// 
    /// ```swift
    /// let unit = Time.in(.seconds)
    /// ```
    static func `in`<Unit: Convertible>(_ unit: Unit) -> Unit where Self == Unit.Base {
        unit
    }
    /// Measures an object to obtain a measurement in this dimension.
    /// - Parameters:
    ///   - unit: Unit associated to the quantity.
    ///   - value: Function that measures the quantity.
    ///
    /// - Returns: A function that receives an object and outputs it's measurement,
    static func measure<T, Unit: Convertible, Value>(
        _: T.Type = T.self,
        in unit: Unit,
        f value: @escaping (T) -> Value
    ) -> (T) -> Measurement<Unit, Value> where Unit.Base == Self {
        Unit.measure(in: unit, f: value)
    }
    /// Defines a dynamic measurement in the given dimension.
    /// - Parameters:
    ///   - value: Quantity for the measure.
    ///   - unit: Unit of measure.
    ///
    /// - Returns: A new measurement in the given dimension.
    /// 
    /// Example:
    /// ```swift
    /// let oneMeter = Length.of(1, meter)
    /// ```
    static func of<Unit: Convertible, Value>(
        _ value: Value,
        _ unit: Unit
    ) -> Measurement<Unit, Value> where Unit.Base == Self {
        .init(value, unit)
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag: Dimension {
    /// Static unit from the dimension to be used.
    /// - Parameter unit: Reference to the static unit's type.
    /// - Returns: Static unit as a type.
    /// 
    /// Works as an easy DotSyntax accessor for the static units of a given dimension:
    /// 
    /// ```swift
    /// let unit = Tagged<Time, Double>.in(\.seconds)
    /// ```
    static func `in`<Unit: StaticQuantifiable, T>(
        _: KeyPath<Self, Tagged<Unit, T>>
    ) -> Tagged<Unit, T>.Type {
        Tagged<Unit, T>.self
    }
}

public extension Dimension {
    /// Defines a tagged value in the given dimension.
    /// - Parameter value: Quantity for the measure.
    /// - Returns: A new tagged measure in the given dimension.
    /// 
    /// Example:
    /// ```swift
    /// let oneMeter = Length.of(1, \.meter)
    /// ```
    static func of<Unit: StaticUnit, Value>(
        _ value: Value,
        _: KeyPath<Tagged<Self, Value>, Tagged<Unit, Value>>
    ) -> Tagged<Unit, Value> where Unit.Base == Self {
        .init(value)
    }
}
