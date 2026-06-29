//
//  ExponentialUnit+Tagged.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/05/2026.
//

import Tagged

// MARK: DotSyntax
@available(macOS 26.0, *)
public extension ExponentialUnit {
    /// Defines a tagged value in the given exponential base.
    /// - Parameter value: Quantity for the measure.
    /// - Returns: A new exponential tagged measure in the given dimension.
    /// 
    /// Example:
    /// ```swift
    /// let oneSquareMeter = Exponential<Length, 2>.of(1, \.meter)
    /// ```
    static func of<Value>(
        _ value: Value,
        _: KeyPath<Tagged<T.Base, Value>, Tagged<T, Value>>
    ) -> Tagged<ExponentialUnit<T, N>, Value> where T: StaticUnit {
        .init(value)
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
    static func of<Value>(
        _ value: Value,
        _: KeyPath<T, ExponentialUnit<T, N>>,
        _: KeyPath<Tagged<T.Base, Value>, Tagged<T, Value>>
    ) -> Tagged<ExponentialUnit<T, N>, Value> where T: StaticUnit {
        .init(value)
    }
}

// MARK: Tagged (EX)
@available(macOS 26.0, *)
public extension Tagged {
    /// Creates a squared static unit.
    /// - Returns: Tagged reference to a squared static unit type.
    static func square(
        _: KeyPath<Tagged<Tag.Base, RawValue>, Tagged<Tag, RawValue>>
    ) -> Tagged<Square<Tag>, RawValue>.Type where Tag: StaticUnit {
        Tagged<Square<Tag>, RawValue>.self
    }
    /// Creates a cubic static unit.
    /// - Returns: Tagged reference to a cubic static unit type.
    static func cubic(
        _: KeyPath<Tagged<Tag.Base, RawValue>, Tagged<Tag, RawValue>>
    ) -> Tagged<Cubic<Tag>, RawValue>.Type where Tag: StaticUnit {
        Tagged<Cubic<Tag>, RawValue>.self
    }
    /// Static unit from the dimension to be used.
    /// - Returns: Exponential static unit as a type.
    /// 
    /// Works as an easy DotSyntax accessor for the static exponential units:
    /// 
    /// ```swift
    /// let unit = Exponential<Time, 2>.in(.seconds)
    /// ```
    static func `in`<let power: Int, Unit: StaticUnit>(
        _: KeyPath<Tagged<Unit.Base, RawValue>, Tagged<Unit, RawValue>>
    ) -> Self.Type where Tag == ExponentialUnit<Unit, power> {
        Self.self
    }
}

@available(macOS 26.0, *)
public extension Tagged where Tag: StaticUnit {
    /// Short alias for an exponential tagged value.
    typealias E<let power: Int> = Tagged<ExponentialUnit<Tag, power>, RawValue>
}

@available(macOS 26.0, *)
public extension Tagged where RawValue: BinaryFloatingPoint {
    /// Automatically converts an exponential value to a base unit.
    ///
    /// - Returns: Tagged base value that applies all of the exponentials.
    /// 
    /// Works as an easy way to let the compiler infer the power for the type based on the target type.
    func pow<T, let power: Int>() -> Tagged<T, RawValue> where Tag == ExponentialUnit<T, power> {
        .init(RawValue(Double.pow(Double(rawValue), power)))
    }
    /// Automatically converts a base value to an exponential unit.
    ///
    /// - Returns: Exponential tagged value that puts back the exponential in the tag.
    /// 
    /// Works as an easy way to let the compiler infer the power for the type based on the target type.
    func root<let power: Int>() -> Tagged<ExponentialUnit<Tag, power>, RawValue> {
        .init(RawValue(Double.root(Double(rawValue), power)))
    }
    /// Converts an exponential value to a target unit.
    /// - Parameter converter: Static converter between unit types (without exponents).
    /// - Returns: Tagged value on the target unit.
    func pow<T, O, let power: Int>(
        _ converter: (Tagged<T, RawValue>) -> Tagged<O, RawValue>
    ) -> Tagged<O, RawValue> where Tag == ExponentialUnit<T, power> {
        .init(RawValue(Double.pow(Double(converter(.init(rawValue)).rawValue), power)))
    }
    /// Converts a tagged value to a target exponential unit.
    /// - Parameter converter: Static converter between unit types (without exponents).
    /// - Returns: Tagged exponential value.
    func root<T, let power: Int>(
        _ converter: (Self) -> Tagged<T, RawValue>
    ) -> Tagged<ExponentialUnit<T, power>, RawValue> {
        .init(converter(.init(RawValue(Double.root(Double(rawValue), power)))).rawValue)
    }
}
