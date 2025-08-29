//
//  Dimensionality.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/08/2025.
//

public struct Dimensionality {
    // MARK: Variables
    var domains: [ObjectIdentifier: Int]

    var isNone: Bool { domains.isEmpty }

    // MARK: Subscripts
    subscript<D: Dimension>(domainType: D.Type) -> Int {
        let key = ObjectIdentifier(domainType)

        return domains[key] ?? 0
    }

    // MARK: Initializers
    private init(dict: [ObjectIdentifier: Int]) {
        self.domains = dict
    }

    public init<D: Dimension>(_ type: D.Type) {
        self.init(dictionaryLiteral: (type, 1))
    }

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
    static let dimensionless: Self = [:]
}

// MARK: Operators
public extension Dimensionality {
    static func + (lhs: Self, rhs: Self) -> Self {
        var result = Dimensionality(dict: lhs.domains)
        rhs.domains.forEach { result.register($0.key, e: $0.value) }
        return result
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        var result = Dimensionality(dict: lhs.domains)
        rhs.domains.forEach { result.register($0.key, e: -$0.value) }
        return result
    }

    static func * (lhs: Self, rhs: Int) -> Self {
        if rhs == 0 { return .dimensionless }

        return .init(dict: lhs.domains.mapValues { $0 * rhs })
    }
}

// MARK: Self: ExpressibleByDictionaryLiteral
extension Dimensionality: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (any Dimension.Type, Int)...) {
        self.init(elements)
    }
}

// MARK: Self: Equatable
extension Dimensionality: Equatable {}

// MARK: Self: Sendable
extension Dimensionality: Sendable {}
