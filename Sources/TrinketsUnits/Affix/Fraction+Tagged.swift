//
//  Fraction+Tagged.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged

// MARK: DotSyntax
public extension Fraction {
    /// Creates a new fraction between units.
    /// - Returns: Fraction of a static unit by another.
    static func of<Value>(
        _ value: Value,
        _: KeyPath<Tagged<A.Base, Value>, Tagged<A, Value>>,
        per _: KeyPath<Tagged<B.Base, Value>, Tagged<B, Value>>
    ) -> Tagged<Fraction<A, B>, Value> where A: StaticUnit, B: StaticUnit {
        .init(value)
    }
}

public extension Tagged {
    /// Creates a new fraction between units.
    /// - Returns: Fraction of a static unit by another.
    static func `in`<A: StaticUnit, B: StaticUnit, T>(
        _: KeyPath<Tagged<A.Base, RawValue>, Tagged<A, T>>,
        per _: KeyPath<Tagged<B.Base, RawValue>, Tagged<B, T>>
    ) -> Tagged<Fraction<A, B>, T>.Type where Tag == Fraction<A.Base, B.Base> {
        Tagged<Fraction<A, B>, T>.self
    }
    /// Creates a fraction by dividing the current tag by a static unit.
    /// - Returns: Reference to a `Fraction` type of the given tag by a static unit.
    static func per<S: StaticUnit, T>(
        _: KeyPath<Tagged<S.Base, RawValue>, Tagged<S, T>>
    ) -> Tagged<Fraction<Tag, S>, T>.Type {
        Tagged<Fraction<Tag, S>, T>.self
    }
    /// Creates a domain fraction by dividing the current tag by a domain.
    /// - Returns: Reference to a `Fraction` type of the given tag and domain.
    static func per<D: Domain>(
        _: D.Type
    ) -> Tagged<Fraction<Tag, D>, RawValue>.Type where Tag: StaticUnit {
        Tagged<Fraction<Tag, D>, RawValue>.self
    }
}

// MARK: Domain (EX)
public extension Domain {
    /// Creates a domain fraction by dividing the current domain by a reference to another.
    /// - Returns: Reference to a `Fraction` type of the given domains.
    static func per<D: Domain>(
        _: D.Type
    ) -> Fraction<Self, D>.Type {
        Fraction<Self, D>.self
    }
    /// Creates a domain fraction by dividing the current domain by a reference to a static unit.
    /// - Returns: Reference to a `Fraction` type of the given domain and static unit.
    static func per<S: StaticUnit>(
        _: S.Type
    ) -> Fraction<Self, S>.Type {
        Fraction<Self, S>.self
    }
}

// MARK: StaticUnit (EX)
public extension StaticUnit {
    /// Creates a fraction by dividing the current static unit by a domain.
    /// - Returns: Reference to a `Fraction` type of the given static unit by the domain.
    static func per<D: Domain>(
        _: D.Type
    ) -> Fraction<Self, D>.Type {
        Fraction<Self, D>.self
    }
    /// Creates a domain fraction by dividing the current domain by a reference to a static unit.
    /// - Returns: Reference to a `Fraction` type of the given domain and static unit.
    static func per<S: StaticUnit>(
        _: S.Type
    ) -> Fraction<Self, S>.Type {
        Fraction<Self, S>.self
    }
}

// MARK: Tagged (EX)
public extension Tagged where Tag: StaticUnit, RawValue: FloatingPoint {
    /// Divides a tagged value by another.
    /// - Parameter denominator: A tagged value.
    /// - Returns: A new tagged value with the division of quantities associated to a `Fraction` tag.
    func per<T: StaticUnit>(_ denominator: Tagged<T, RawValue>) -> Tagged<Fraction<Tag, T>, RawValue> {
        .init(rawValue / denominator.rawValue)
    }
    /// Divides a tagged value by another.
    /// - Parameters:
    ///   - lhs: A tagged value
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the division of quantities associated to a `Fraction` tag.
    static func / <T: StaticUnit>(lhs: Self, rhs: Tagged<T, RawValue>) -> Tagged<Fraction<Tag, T>, RawValue> {
        lhs.per(rhs)
    }
}

public extension Tagged where Tag: Domain, RawValue: FloatingPoint {
    /// Divides a tagged value by a domain tagged value.
    /// - Parameter denominator: A tagged domain value.
    /// - Returns: A new tagged value with the division of quantities associated to a `Fraction` tag.
    func per<T: Domain>(_ denominator: Tagged<T, RawValue>) -> Tagged<Fraction<Tag, T>, RawValue> {
        .init(rawValue / denominator.rawValue)
    }
    /// Divides a tagged value by a domain tagged value.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the division of quantities associated to a `Fraction` tag.
    static func / <T: Domain>(lhs: Self, rhs: Tagged<T, RawValue>) -> Tagged<Fraction<Tag, T>, RawValue> {
        lhs.per(rhs)
    }
}

public extension Tagged {
    /// Transforms a tagged value to another fraction by converting it's numerator.
    /// - Parameter converter: Static converter for the numerator.
    /// - Returns: A new tagged value with the converted quantity.
    func convertNumerator<A, B, C>(
        _ converter: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<Fraction<C, B>, RawValue> where Tag == Fraction<A, B> {
        .init(converter(.init(rawValue)).rawValue)
    }
    /// Transforms a tagged value to another fraction by converting it's denominator.
    /// - Parameter converter: Static converter for the denominator.
    /// - Returns: A new tagged value with the converted quantity.
    func convertDenominator<A, B, C>(
        _ converter: (Tagged<B, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<Fraction<A, C>, RawValue> where Tag == Fraction<A, B> {
        .init(converter(.init(rawValue)).rawValue)
    }
    /// Converts to another fraction, applying conversions from denominator, then numerator.
    /// - Parameters:
    ///   - lhs: A static converter for the denominator.
    ///   - rhs: Another static converter for the numerator.
    ///
    /// - Returns: Converted value.
    func denominator<A, B, C, D>(
        _ rhs: (Tagged<B, RawValue>) -> Tagged<D, RawValue>,
        then lhs: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<Fraction<C, D>, RawValue> where Tag == Fraction<A, B> {
        convertDenominator(rhs).convertNumerator(lhs)
    }
    /// Converts to another fraction, applying conversions from numerator, then denominator.
    /// - Parameters:
    ///   - lhs: A static converter, for the numerator.
    ///   - rhs: Another static converter, for the denominator.
    ///
    /// - Returns: Converted value.
    func numerator<A, B, C, D>(
        _ lhs: (Tagged<A, RawValue>) -> Tagged<C, RawValue>,
        then rhs: (Tagged<B, RawValue>) -> Tagged<D, RawValue>
    ) -> Tagged<Fraction<C, D>, RawValue> where Tag == Fraction<A, B> {
        convertNumerator(lhs).convertDenominator(rhs)
    }
}
