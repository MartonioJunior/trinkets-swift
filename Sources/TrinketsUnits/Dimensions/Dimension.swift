//
//  Dimension.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Foundation

/// Domain that defines a common base value for a set of units.
public protocol Dimension: Domain {
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

public extension Dimension {
    /// Static unit from the dimension to be used.
    /// - Parameter unit: Reference to the static unit's type.
    /// - Returns: Static unit as a type.
    /// 
    /// Works as an easy DotSyntax accessor for the static units of a given dimension:
    /// 
    /// ```swift
    /// let unit = Time.in(.seconds)
    /// ```
    static func `in`<Unit: StaticUnit>(
        _ unit: Tagged<Self, Unit.Type>
    ) -> Unit.Type where Self == Unit.Base {
        unit.rawValue
    }
    /// Measures an object to obtain a tagged value in this dimension using a static unit.
    /// - Parameters:
    ///   - value: Function that measures the quantity.
    ///
    /// - Returns: A function that receives an object and outputs it's tagged value,
    static func measure<T, Unit: StaticUnit, Value>(
        _: T.Type = T.self,
        in _: Tagged<Self, Unit.Type>,
        f value: @escaping (T) -> Value
    ) -> (T) -> Tagged<Unit, Value> {
        Unit.measure(f: value)
    }
    /// Defines a tagged value in the given dimension.
    /// - Parameter value: Quantity for the measure.
    /// - Returns: A new tagged measure in the given dimension.
    /// 
    /// Example:
    /// ```swift
    /// let oneMeter = Length.of(1, .meter)
    /// ```
    static func of<Unit: StaticUnit, Value>(
        _ value: Value,
        _: Tagged<Self, Unit.Type>
    ) -> Tagged<Unit, Value> where Unit.Base == Self {
        .init(value)
    }
}
