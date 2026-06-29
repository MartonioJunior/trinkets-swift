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
    static func of<Value>(
        _ value: Value,
        _: KeyPath<Tagged<A.Base, Value>, Tagged<A, Value>>,
        _: KeyPath<Tagged<B.Base, Value>, Tagged<B, Value>>
    ) -> Tagged<ProductUnit<A, B>, Value> where A: StaticUnit, B: StaticUnit {
        .init(value)
    }
}

public extension Tagged {
    /// Creates a new unit product from two unit types.
    /// - Returns: Product of static units.
    static func `in`<A: StaticUnit, B: StaticUnit, T>(
        _: KeyPath<Tagged<A.Base, RawValue>, Tagged<A, T>>,
        _: KeyPath<Tagged<B.Base, RawValue>, Tagged<B, T>>
    ) -> Tagged<ProductUnit<A, B>, T>.Type where Tag == ProductUnit<A.Base, B.Base> {
        Tagged<ProductUnit<A, B>, T>.self
    }

    static func times<A: StaticUnit, T>(
        _: KeyPath<Tagged<A.Base, RawValue>, Tagged<A, T>>
    ) -> Tagged<ProductUnit<Tag, A>, T>.Type {
        Tagged<ProductUnit<Tag, A>, T>.self
    }

    static func times<D: Domain>(
        _: D.Type
    ) -> Tagged<ProductUnit<Tag, D>, RawValue>.Type {
        Tagged<ProductUnit<Tag, D>, RawValue>.self
    }
}

// MARK: Domain (EX)
public extension Domain {
    /// Combines domains into a product.
    /// - Returns: Reference to a `Product` type of the given domains.
    static func times<D: Domain>(
        _: D.Type
    ) -> ProductUnit<Self, D>.Type {
        ProductUnit<Self, D>.self
    }
    /// Combines a domain and a static unit into a product.
    /// - Returns: Reference to a `Product` type of the given domain and static unit.
    static func times<S: StaticUnit>(
        _: S.Type
    ) -> ProductUnit<Self, S>.Type {
        ProductUnit<Self, S>.self
    }
}

// MARK: StaticUnit (EX)
public extension StaticUnit {
    /// Combines a static unit and a domain into a product.
    /// - Returns: Reference to a `Product` type of the given static unit and domain.
    static func times<D: Domain>(
        _: D.Type
    ) -> ProductUnit<Self, D>.Type {
        ProductUnit<Self, D>.self
    }
    /// Combines static units into a product.
    /// - Returns: Reference to a `Product` type of the given static units.
    static func times<S: StaticUnit>(
        _: S.Type
    ) -> ProductUnit<Self, S>.Type {
        ProductUnit<Self, S>.self
    }
}

// MARK: Tagged (EX)
public extension Tagged where Tag: StaticUnit, RawValue: Numeric {
    /// Multiplies a tagged value with another.
    /// - Parameter other: A tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    func multiply<T: StaticUnit>(by other: Tagged<T, RawValue>) -> Tagged<ProductUnit<Tag, T>.Base, RawValue> {
        .init(rawValue * other.rawValue)
    }
    /// Multiplies a tagged value with another.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    static func * <T: StaticUnit>(lhs: Self, rhs: Tagged<T, RawValue>) -> Tagged<ProductUnit<Tag, T>.Base, RawValue> {
        lhs.multiply(by: rhs)
    }
}

public extension Tagged where Tag: Domain, RawValue: Numeric {
    /// Multiplies a tagged value with another.
    /// - Parameter other: A tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    func multiply<T: Domain>(by other: Tagged<T, RawValue>) -> Tagged<ProductUnit<Tag, T>, RawValue> {
        .init(rawValue * other.rawValue)
    }
    /// Multiplies a tagged value with another.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    static func * <T: Domain>(lhs: Self, rhs: Tagged<T, RawValue>) -> Tagged<ProductUnit<Tag, T>, RawValue> {
        lhs.multiply(by: rhs)
    }
}

public extension Tagged {
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
    func first<A, B, C, D>(
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
    func second<A, B, C, D>(
        _ rhs: (Tagged<B, RawValue>) -> Tagged<D, RawValue>,
        then lhs: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<ProductUnit<C, D>, RawValue> where Tag == ProductUnit<A, B> {
        convertSecond(rhs).convertFirst(lhs)
    }
}
