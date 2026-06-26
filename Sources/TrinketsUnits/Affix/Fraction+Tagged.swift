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
    static func of(
        _: Tagged<A.Base, A.Type>,
        per _: Tagged<B.Base, B.Type>
    ) -> Fraction<A, B>.Type where A: StaticUnit, B: StaticUnit {
        Fraction<A, B>.self
    }
    /// Creates a new fraction between units.
    /// - Returns: Fraction of a base with a static unit.
    static func of(
        _: Tagged<A, A.Type>,
        per _: Tagged<B.Base, B.Type>
    ) -> Tagged<Fraction<A, B>, Fraction<A, B>.Type> where B: StaticUnit {
        .init(Fraction<A, B>.self)
    }
    /// Creates a new fraction between units.
    /// - Returns: Fraction of a static unit with a base.
    static func of(
        _: Tagged<A.Base, A.Type>,
        per _: Tagged<B, B.Type>
    ) -> Tagged<Fraction<A, B>, Fraction<A, B>.Type> where A: StaticUnit {
        .init(Fraction<A, B>.self)
    }
}

// MARK: Domain (EX)
public extension Domain {
    /// Creates a fraction by dividing the current domain by a static unit.
    /// - Returns: Reference to a `Fraction` type of the given domain by a static unit.
    static func per<T: StaticUnit>(
        _: Tagged<T.Base, T.Type>
    ) -> Tagged<Fraction<Self, T.Base>, Fraction<Self, T>.Type> {
        .init(Fraction<Self, T>.self)
    }
    /// Creates a domain fraction by dividing the current domain by a reference to another.
    /// - Returns: Reference to a `Fraction` type of the given domains.
    static func per<T: Domain>(
        _: T.Type
    ) -> Fraction<Self, T>.Type {
        Fraction<Self, T>.self
    }
}

// MARK: StaticUnit (EX)
public extension StaticUnit {
    /// Creates a unit fraction by dividing the current static unit by a reference to another.
    /// - Returns: Reference to a `Fraction` type of the given static units.
    static func per<T: StaticUnit>(
        _: Tagged<T.Base, T.Type>
    ) -> Tagged<Fraction<Self, T>.Base, Fraction<Self, T>.Type> {
        .init(Fraction<Self, T>.self)
    }
    /// Creates a fraction by dividing the current static unit by a domain.
    /// - Returns: Reference to a `Fraction` type of the given static unit by the domain.
    static func per<T: Domain>(
        _: T.Type
    ) -> Tagged<Fraction<Self.Base, T>, Fraction<Self, T>.Type> {
        .init(Fraction<Self, T>.self)
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
    /// Defines a reference to a type of fraction.
    /// - Returns: Reference to the fraction type.
    static func fraction<A: StaticUnit, B: StaticUnit>(
        _: Tagged<A.Base, A.Type>,
        per _: Tagged<B.Base, B.Type>
    ) -> Self where Tag == Fraction<A, B>.Base, RawValue == Fraction<A, B>.Type {
        .init(Fraction<A, B>.self)
    }
}
