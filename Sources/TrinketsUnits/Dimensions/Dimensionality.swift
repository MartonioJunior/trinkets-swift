//
//  Dimensionality.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/08/2025.
//

/// Data structure that defines the dimensionality of a given dimension.
/// 
/// Dimensionality is described by a pair of one or more dimensions with their respective power exponents.
/// 
/// If a dimension cannot be described in terms of it's relationships to other dimensions or itself,
/// it's said that the dimension is dimensionless, with an empty dimensionality.
public struct Dimensionality {
    // MARK: Variables
    /// Dimensions and their respective exponents.
    var domains: [ObjectIdentifier: Int]
    /// Does this dimensionality have any features to it?
    public var isNone: Bool { domains.isEmpty }
    // MARK: Subscripts
    /// Exponent for a given dimension.
    /// - Parameter domainType: Dimension type
    /// - Returns: Exponent for the dimension. If the dimension is not registered in, returns 0.
    public subscript<D: Dimension>(domainType: D.Type) -> Int {
        let key = ObjectIdentifier(domainType)

        return domains[key] ?? 0
    }
    // MARK: Initializers
    /// Creates a new dimensionality via type exponents.
    /// - Parameter dict: Dictionary with registered exponents.
    private init(dict: [ObjectIdentifier: Int]) {
        self.domains = dict
    }
    /// Creates a new dimensionality using a dimension as the base (exponent 1).
    /// - Parameter type: Dimension type used as base.
    public init<D: Dimension>(_ type: D.Type) {
        self.init(dictionaryLiteral: (type, 1))
    }
    /// Creates a new dimensionality using a sequence of dimension types and exponents.
    /// - Parameter elements: Sequence of dimension-exponent pairs.
    public init(_ elements: some Sequence<(any Dimension.Type, Int)>) {
        domains = [:]

        for item in elements {
            register(item.0, e: item.1)
        }
    }

    // MARK: Methods
    private mutating func register<D: Dimension>(_ item: D.Type, e: Int) {
        register(ObjectIdentifier(item), e: e)
    }

    /// Adds the given exponent to a type.
    /// - Parameters:
    ///   - key: Key to the dimension type.
    ///   - e: Exponent added in.
    ///
    private mutating func register(_ key: ObjectIdentifier, e: Int) {
        let sum = domains[key, default: 0] + e

        guard sum != 0 else {
            domains.removeValue(forKey: key)
            return
        }

        domains[key] = sum
    }
}

// MARK: DotSyntax
public extension Dimensionality {
    /// Empty dimensionality with no components.
    static let dimensionless: Self = [:]
}

// MARK: Operators
public extension Dimensionality {
    /// Combines two dimensionalities together
    /// - Parameters:
    ///   - lhs: A dimensionality.
    ///   - rhs: Another dimensionality.
    ///
    /// - Returns: A new `Dimensionality` that combines both of it's features.
    static func + (lhs: Self, rhs: Self) -> Self {
        var result = Dimensionality(dict: lhs.domains)
        rhs.domains.forEach { result.register($0.key, e: $0.value) }
        return result
    }
    /// Difference between two dimensionalities
    /// - Parameters:
    ///   - lhs: A dimensionality.
    ///   - rhs: Another dimensionality
    ///
    /// - Returns: A new `Dimensionality` with the difference between both dimensionalities.
    static func - (lhs: Self, rhs: Self) -> Self {
        var result = Dimensionality(dict: lhs.domains)
        rhs.domains.forEach { result.register($0.key, e: -$0.value) }
        return result
    }
    /// Increases the dimensionality by a given power.
    /// - Parameters:
    ///   - lhs: A dimensionality.
    ///   - rhs: Exponent power to multiply all features.
    ///
    /// - Returns: A new `Dimensionality` with all exponents multiplied by power.
    static func * (lhs: Self, rhs: Int) -> Self {
        if rhs == 0 { return .dimensionless }

        return .init(dict: lhs.domains.mapValues { $0 * rhs })
    }
}

// MARK: Self: ExpressibleByDictionaryLiteral
extension Dimensionality: ExpressibleByDictionaryLiteral {
    // swiftlint:disable:next missing_docs
    public init(dictionaryLiteral elements: (any Dimension.Type, Int)...) {
        self.init(elements)
    }
}

// MARK: Self: Equatable
extension Dimensionality: Equatable {}

// MARK: Self: Sendable
extension Dimensionality: Sendable {}
