//
//  Exponential+Tagged.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/05/2026.
//

import Tagged

// MARK: DotSyntax
@available(macOS 26.0, *)
public extension Exponential {
    /// Static unit from the dimension to be used.
    /// - Returns: Exponential static unit as a type.
    /// 
    /// Works as an easy DotSyntax accessor for the static exponential units:
    /// 
    /// ```swift
    /// let unit = Exponential<Time, 2>.in(.seconds)
    /// ```
    static func `in`(
        _: Tagged<T.Base, T.Type>
    ) -> Self.Type where T: StaticUnit {
        Self.self
    }
    /// Defines a tagged value in the given exponential base.
    /// - Parameter value: Quantity for the measure.
    /// - Returns: A new exponential tagged measure in the given dimension.
    /// 
    /// Example:
    /// ```swift
    /// let oneSquareMeter = Exponential<Length, 2>.of(1, .meter)
    /// ```
    static func of<Value>(
        _ value: Value,
        _: Tagged<T.Base, T.Type> = .init(T.self)
    ) -> Tagged<Self, Value> where T: StaticUnit {
        .init(value)
    }
}

// MARK: Dimension (EX)
@available(macOS 26.0, *)
public extension Dimension {
    /// Exponential unit of the dimension to be used.
    ///
    /// - Returns: Desired exponential unit type.
    /// 
    /// Works as an easy DotSyntax accessor for units of a given dimension:
    /// 
    /// ```swift
    /// let unit = Time.in(cubic, seconds)
    /// ``` 
    static func `in`<let N: Int, Unit: StaticUnit>(
        _: Tagged<Exponential<Unit, N>, Exponential<Unit, N>.Type>,
        _: Tagged<Self, Unit.Type>
    ) -> Exponential<Unit, N>.Type where Self == Unit.Base {
        Exponential<Unit, N>.self
    }
    /// Defines an exponential tagged value in the given dimension.
    /// - Parameters:
    ///   - value: Quantity for the measure.
    ///
    /// - Returns: Desired exponential tagged value.
    /// 
    /// Example:
    /// ```swift
    /// let oneSquareMeter = Length.of(1, square, meter)
    /// ```
    static func of<let N: Int, Unit: StaticUnit, Value>(
        _ value: Value,
        _: Tagged<Exponential<Unit, N>, Exponential<Unit, N>.Type>,
        _: Tagged<Self, Unit.Type>
    ) -> Tagged<Exponential<Unit, N>, Value> where Self == Unit.Base {
        .init(value)
    }
}

// MARK: Tagged (EX)
@available(macOS 26.0, *)
public extension Tagged {
    /// Creates a squared static unit.
    /// - Returns: Tagged reference to a squared static unit type.
    static func square<Unit: StaticUnit>(
        _: Unit.Type = Unit.self
    ) -> Self where Tag == Square<Unit>, RawValue == Square<Unit>.Type {
        .init(Square<Unit>.self)
    }
    /// Creates a cubic static unit.
    /// - Returns: Tagged reference to a cubic static unit type.
    static func cubic<Unit: StaticUnit>(
        _: Unit.Type = Unit.self
    ) -> Self where Tag == Cubic<Unit>, RawValue == Cubic<Unit>.Type {
        .init(Cubic<Unit>.self)
    }
}

@available(macOS 26.0, *)
public extension Tagged where Tag: StaticUnit {
    /// Short alias for an exponential tagged value.
    typealias E<let N: Int> = Tagged<Exponential<Tag, N>, RawValue>
}

@available(macOS 26.0, *)
public extension Tagged where RawValue: BinaryFloatingPoint {
    /// Automatically converts an exponential value to a base unit.
    ///
    /// - Returns: Tagged base value that applies all of the exponentials.
    /// 
    /// Works as an easy way to let the compiler infer the power for the type based on the target type.
    func pow<T, let N: Int>() -> Tagged<T, RawValue> where Tag == Exponential<T, N> {
        .init(RawValue(Double.pow(Double(rawValue), N)))
    }
    /// Automatically converts a base value to an exponential unit.
    ///
    /// - Returns: Exponential tagged value that puts back the exponential in the tag.
    /// 
    /// Works as an easy way to let the compiler infer the power for the type based on the target type.
    func root<let N: Int>() -> Tagged<Exponential<Tag, N>, RawValue> {
        .init(RawValue(Double.root(Double(rawValue), N)))
    }
    /// Converts an exponential value to a target unit.
    /// - Parameter converter: Static converter between unit types (without exponents).
    /// - Returns: Tagged value on the target unit.
    func pow<T, O, let N: Int>(
        _ converter: (Tagged<T, RawValue>) -> Tagged<O, RawValue>
    ) -> Tagged<O, RawValue> where Tag == Exponential<T, N> {
        .init(RawValue(Double.pow(Double(converter(.init(rawValue)).rawValue), N)))
    }
    /// Converts a tagged value to a target exponential unit.
    /// - Parameter converter: Static converter between unit types (without exponents).
    /// - Returns: Tagged exponential value.
    func root<T, let N: Int>(
        _ converter: (Self) -> Tagged<T, RawValue>
    ) -> Tagged<Exponential<T, N>, RawValue> {
        .init(converter(.init(RawValue(Double.root(Double(rawValue), N)))).rawValue)
    }
}
