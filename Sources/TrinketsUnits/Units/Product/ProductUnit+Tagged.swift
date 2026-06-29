//
//  ProductUnit+Tagged.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged

// MARK: DotSyntax
public extension ProductUnit {
    /// Creates a new unit product from two unit types.
    /// - Returns: Product of a static unit with another.
    static func of<Value, Da: Domain, Db: Domain>(
        _ value: Value,
        _: KeyPath<Tagged<Da, Value>, Tagged<A, Value>>,
        _: KeyPath<Tagged<Db, Value>, Tagged<B, Value>>
    ) -> Tagged<ProductUnit<A, B>, Value> where A: StaticQuantifiable, B: StaticQuantifiable {
        .init(value)
    }
}

public extension Tagged {
    /// Creates a new unit product from two unit types.
    /// - Returns: Product of static units.
    static func `in`<A: StaticQuantifiable, B: StaticQuantifiable, Da: Domain, Db: Domain, T>(
        _: KeyPath<Tagged<Da, RawValue>, Tagged<A, T>>,
        _: KeyPath<Tagged<Db, RawValue>, Tagged<B, T>>
    ) -> Tagged<ProductUnit<A, B>, T>.Type where Tag == ProductUnit<Da, Db> {
        Tagged<ProductUnit<A, B>, T>.self
    }
    /// Creates a domain product by multiplying the current domain by a reference to a static unit.
    /// - Returns: Product of static units.
    static func times<D: Domain, S: StaticQuantifiable, T>(
        _: KeyPath<Tagged<D, RawValue>, Tagged<S, T>>
    ) -> Tagged<ProductUnit<Tag, S>, T>.Type {
        Tagged<ProductUnit<Tag, S>, T>.self
    }
    /// Combines static units into a product.
    /// - Returns: Reference to a `Product` type of the given static units.
    static func times<S: StaticQuantifiable>(_: S.Type) -> Tagged<ProductUnit<Tag, S>, RawValue>.Type {
        Tagged<ProductUnit<Tag, S>, RawValue>.self
    }
}

// MARK: StaticQuantifiable (EX)
public extension StaticQuantifiable {
    /// Combines static units into a product.
    /// - Returns: Reference to a `Product` type of the given static units.
    static func times<S: StaticQuantifiable>(_: S.Type) -> ProductUnit<Self, S>.Type {
        ProductUnit<Self, S>.self
    }
}

// MARK: Tagged (EX)
public extension Tagged where Tag: StaticQuantifiable, RawValue: Numeric {
    /// Multiplies a tagged value with another.
    /// - Parameter other: A tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    func multiply<T: StaticQuantifiable>(by other: Tagged<T, RawValue>) -> Tagged<ProductUnit<Tag, T>.Base, RawValue> {
        .init(rawValue * other.rawValue)
    }
    /// Multiplies a tagged value with another.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    static func * <T: StaticQuantifiable>(
        lhs: Self,
        rhs: Tagged<T, RawValue>
    ) -> Tagged<ProductUnit<Tag, T>.Base, RawValue> {
        lhs.multiply(by: rhs)
    }
}

public extension Tagged where Tag: StaticQuantifiable {
    /// Transforms a tagged value to another product by converting it's first factor.
    /// - Parameter converter: Static converter for the first factor.
    /// - Returns: A new tagged value with the converted quantity.
    func convertFirst<A, B, C>(
        _ converter: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<ProductUnit<C, B>, RawValue> where Tag == ProductUnit<A, B> {
        .init(converter(.init(rawValue)).rawValue)
    }
    /// Transforms a tagged value to another product by converting it's second factor.
    /// - Parameter converter: Static converter for the second factor.
    /// - Returns: A new tagged value with the converted quantity.
    func convertSecond<A, B, C>(
        _ converter: (Tagged<B, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<ProductUnit<A, C>, RawValue> where Tag == ProductUnit<A, B> {
        .init(converter(.init(rawValue)).rawValue)
    }
    /// Converts to another product, applying conversions from left-to-right.
    /// - Parameters:
    ///   - lhs: A static converter.
    ///   - rhs: Another static converter.
    ///
    /// - Returns: Converted value.
    func first<A, B, C: StaticQuantifiable, D: StaticQuantifiable>(
        _ lhs: (Tagged<A, RawValue>) -> Tagged<C, RawValue>,
        then rhs: (Tagged<B, RawValue>) -> Tagged<D, RawValue>
    ) -> Tagged<ProductUnit<C, D>, RawValue> where Tag == ProductUnit<A, B> {
        convertFirst(lhs).convertSecond(rhs)
    }
    /// Converts to another product, applying conversions from right-to-left.
    /// - Parameters:
    ///   - lhs: A static converter.
    ///   - rhs: Another static converter.
    ///
    /// - Returns: Converted value.
    func second<A, B, C: StaticQuantifiable, D: StaticQuantifiable>(
        _ rhs: (Tagged<B, RawValue>) -> Tagged<D, RawValue>,
        then lhs: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<ProductUnit<C, D>, RawValue> where Tag == ProductUnit<A, B> {
        convertSecond(rhs).convertFirst(lhs)
    }
}
