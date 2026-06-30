//
//  MetricPrefix.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/06/25.
//

import Numerics

/// Defines a prefix for quantifiable parameters.
public protocol UnitPrefix: Convertible where Base: UnitPrefixSystem {
    /// Exponent applied to the base prefix.
    static var exponent: Int { get }
}

// MARK: Default Implementation
public extension UnitPrefix {
    /// Overall multiplier for a measure.
    static var multiplier: Double {
        Double.pow(Double(Base.base), exponent)
    }
    /// Compares a unit prefix with another in the same base.
    /// - Parameters:
    ///   - lhs: An unit prefix.
    ///   - rhs: Another unit prefix.
    ///
    /// - Returns: `true` when left-hand side is lesser than right-side, `false` otherwise.
    static func < <Other: UnitPrefix>(
        lhs: Self.Type,
        rhs: Other.Type
    ) -> Bool where Self.Base == Other.Base {
        lhs.exponent < rhs.exponent
    }
    // Compares a unit prefix with another unit prefix.
    /// - Parameters:
    ///   - lhs: An unit prefix.
    ///   - rhs: Another unit prefix.
    ///
    /// - Returns: `true` when left-hand side multiplier is greater than right-side, `false` otherwise.
    static func < <Other: UnitPrefix>(
        lhs: Self.Type,
        rhs: Other.Type
    ) -> Bool {
        lhs.multiplier < rhs.multiplier
    }
}

// MARK: Dimension (EX)
public extension Dimension {
    /// Unit from the dimension to be used.
    /// - Parameters:
    ///   - prefix: Reference to the prefix type.
    ///   - unit: Unit to be used.
    /// - Returns: `unit`.
    /// 
    /// Works as an easy DotSyntax accessor for the dynamic units of a given dimension:
    /// 
    /// ```swift
    /// let unit = Time.in(.milli, .seconds)
    /// ```
    static func `in`<Prefix: UnitPrefix, Unit: Convertible>(
        _ prefix: Tagged<Prefix.Base, Prefix.Type>,
        _ unit: Unit
    ) -> PrefixedUnit<Prefix, Unit> where Self == Unit.Base {
        .init(prefix, unit)
    }
    /// Defines a dynamic measurement in the given dimension.
    /// - Parameters:
    ///   - value: Quantity for the measure.
    ///   - prefix: Reference to the prefix type.
    ///   - unit: Unit of measure.
    ///
    /// - Returns: A new measurement in the given dimension.
    /// 
    /// Example:
    /// ```swift
    /// let oneMeter = Length.of(1, kilo, meter)
    /// ```
    static func of<Prefix: UnitPrefix, Unit: Convertible, Value>(
        _ value: Value,
        _ prefix: Tagged<Prefix.Base, Prefix.Type>,
        _ unit: Unit
    ) -> Measurement<PrefixedUnit<Prefix, Unit>, Value> where Self == Unit.Base {
        .init(value, .init(prefix, unit))
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag: Dimension {
    /// Static unit from the dimension to be used.
    /// - Returns: Prefixed static unit as a type.
    /// 
    /// Works as an easy DotSyntax accessor for the static units of a given dimension:
    /// 
    /// ```swift
    /// let unit = Tagged<Time, Double>.in(.milli, \.seconds)
    /// ```
    static func `in`<Prefix: UnitPrefix, Unit: StaticQuantifiable, T>(
        _: Tagged<Prefix.Base, Prefix.Type>,
        _: KeyPath<Self, Tagged<Unit, T>>
    ) -> Tagged<PrefixedUnit<Prefix, Unit>, T>.Type {
        Tagged<PrefixedUnit<Prefix, Unit>, T>.self
    }
}

public extension Dimension {
    /// Defines a prefixed tagged value in the given dimension.
    /// - Parameter value: Quantity for the measure.
    /// - Returns: A new tagged measure in the given dimension, wrapped in an unit prefix.
    /// 
    /// Example:
    /// ```swift
    /// let oneMeter = Length.of(1, .kilo, \.meter)
    /// ```
    static func of<Prefix: UnitPrefix, Unit: StaticUnit, Value>(
        _ value: Value,
        _: Tagged<Prefix.Base, Prefix.Type>,
        _: KeyPath<Tagged<Self, Value>, Tagged<Unit, Value>>
    ) -> Tagged<PrefixedUnit<Prefix, Unit>, Value> where Self == Unit.Base {
        .init(value)
    }
}
