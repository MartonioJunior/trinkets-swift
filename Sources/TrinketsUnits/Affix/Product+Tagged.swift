//
//  Product+Tagged.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged

// MARK: DotSyntax
public extension Product {
    /// Creates a new unit product from two unit types.
    /// - Returns: Product of static units.
    static func of(
        _: Tagged<A.Base, A.Type>,
        _: Tagged<B.Base, B.Type>
    ) -> Product<A, B>.Type where A: StaticUnit, B: StaticUnit {
        Product<A, B>.self
    }
    /// Creates a new unit product from two unit types.
    /// - Returns: Product of a base with static unit.
    static func of(
        _: Tagged<A, A.Type>,
        _: Tagged<B.Base, B.Type>
    ) -> Tagged<Product<A, B>, Product<A, B>.Type> where B: StaticUnit {
        .init(Product<A, B>.self)
    }
    /// Creates a new unit product from two unit types.
    /// - Returns: Product of a static unit with a base.
    static func of(
        _: Tagged<A.Base, A.Type>,
        _: Tagged<B, B.Type>
    ) -> Tagged<Product<A, B>, Product<A, B>.Type> where A: StaticUnit {
        .init(Product<A, B>.self)
    }
}

// MARK: Domain (EX)
public extension Domain {
    /// Combines a domain and a static unit into a product.
    /// - Returns: Reference to a `Product` type of the given domain and static unit.
    static func | <T: StaticUnit>(
        _: Self.Type,
        _: Tagged<T.Base, T.Type>
    ) -> Tagged<Product<Self, T.Base>, Product<Self, T>.Type> {
        .init(Product<Self, T>.self)
    }
    /// Combines domains into a product.
    /// - Returns: Reference to a `Product` type of the given domains.
    static func | <T: Domain>(
        _: Self.Type,
        _: T.Type
    ) -> Product<Self, T>.Type {
        Product<Self, T>.self
    }
}

// MARK: StaticUnit (EX)
public extension StaticUnit {
    /// Combines static units into a product.
    /// - Returns: Reference to a `Product` type of the given static units.
    static func | <T: StaticUnit>(
        _: Self.Type,
        _: Tagged<T.Base, T.Type>
    ) -> Tagged<Product<Self, T>.Base, Product<Self, T>.Type> {
        .init(Product<Self, T>.self)
    }
    /// Combines a static unit and a domain into a product.
    /// - Returns: Reference to a `Product` type of the given static unit and domain.
    static func | <T: Domain>(
        _: Self.Type,
        _: T.Type
    ) -> Tagged<Product<Self.Base, T>, Product<Self, T>.Type> {
        .init(Product<Self, T>.self)
    }
}

// MARK: Tagged (EX)
public extension Tagged where Tag: StaticUnit, RawValue: Numeric {
    /// Multiplies a tagged value with another.
    /// - Parameter other: A tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    func multiply<T: StaticUnit>(by other: Tagged<T, RawValue>) -> Tagged<Product<Tag, T>.Base, RawValue> {
        .init(rawValue * other.rawValue)
    }
    /// Multiplies a tagged value with another.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    static func * <T: StaticUnit>(lhs: Self, rhs: Tagged<T, RawValue>) -> Tagged<Product<Tag, T>.Base, RawValue> {
        lhs.multiply(by: rhs)
    }
}

public extension Tagged where Tag: StaticUnit, RawValue == Tag.Type {
    /// Combines static units into a product.
    /// - Returns: Reference to a `Product` type of the given static units.
    static func | <T: StaticUnit>(
        _: Self,
        _: Tagged<T, T.Type>
    ) -> Tagged<Product<Tag, T>.Base, Product<Tag, T>.Type> {
        .init(Product<Tag, T>.self)
    }
    /// Combines a static unit and a domain into a product.
    /// - Returns: Reference to a `Product` type of the given static unit and domain.
    static func | <T: Domain>(
        _: Self,
        _: T.Type
    ) -> Tagged<Product<Tag, T>, Product<Tag, T>.Type> {
        .init(Product<Tag, T>.self)
    }
}

public extension Tagged where Tag: Domain, RawValue: Numeric {
    /// Multiplies a tagged value with another.
    /// - Parameter other: A tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    func multiply<T: Domain>(by other: Tagged<T, RawValue>) -> Tagged<Product<Tag, T>, RawValue> {
        .init(rawValue * other.rawValue)
    }
    /// Multiplies a tagged value with another.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    /// - Returns: A new tagged value with the product of quantities associated to a `Product` of tags.
    static func * <T: Domain>(lhs: Self, rhs: Tagged<T, RawValue>) -> Tagged<Product<Tag, T>, RawValue> {
        lhs.multiply(by: rhs)
    }
}

public extension Tagged {
    /// Transforms a tagged value to another product by converting it's first factor.
    /// - Parameter converter: Static converter for the first factor.
    /// - Returns: A new tagged value with the converted quantity.
    func convertFirst<A, B, C>(
        _ converter: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<Product<C, B>, RawValue> where Tag == Product<A, B> {
        .init(converter(.init(rawValue)).rawValue)
    }
    /// Transforms a tagged value to another product by converting it's second factor.
    /// - Parameter converter: Static converter for the second factor.
    /// - Returns: A new tagged value with the converted quantity.
    func convertSecond<A, B, C>(
        _ converter: (Tagged<B, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<Product<A, C>, RawValue> where Tag == Product<A, B> {
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
    ) -> Tagged<Product<C, D>, RawValue> where Tag == Product<A, B> {
        convertFirst(lhs).convertSecond(rhs)
    }
    /// Defines a reference to a type of product.
    /// - Returns: Reference to the product type.
    static func product<A: StaticUnit, B: StaticUnit>(
        _: Tagged<A.Base, A.Type>,
        _: Tagged<B.Base, B.Type>
    ) -> Self where Tag == Product<A.Base, B.Base>, RawValue == Product<A, B>.Type {
        .init(Product<A, B>.self)
    }
    /// Converts to another product, applying conversions from right-to-left.
    /// - Parameters:
    ///   - lhs: A static converter.
    ///   - rhs: Another static converter.
    ///
    /// - Returns: Converted value.
    func right<A, B, C, D>(
        _ rhs: (Tagged<B, RawValue>) -> Tagged<D, RawValue>,
        then lhs: (Tagged<A, RawValue>) -> Tagged<C, RawValue>
    ) -> Tagged<Product<C, D>, RawValue> where Tag == Product<A, B> {
        convertSecond(rhs).convertFirst(lhs)
    }
}
