//
//  SyntaxMap.swift
//  Trinkets
//
//  Created by Martônio Júnior on 10/04/2026.
//

public struct SyntaxMap<Key: Hashable, Value> {
    // MARK: Variables
    var defaultValue: Value
    var overrides: [Key: Value]

    public subscript(_ key: Key) -> Value {
        get { overrides[key] ?? defaultValue }
        set { overrides[key] = newValue }
    }

    // MARK: Initializers
    public init(_ overrides: [Key: Value] = [:], default value: Value) {
        self.defaultValue = value
        self.overrides = overrides
    }
}

// MARK: DotSyntax
public extension SyntaxMap where Key: ExpressibleByIntegerLiteral {
    static func pluralized(singular: Value, plural: Value) -> Self {
        .init([1: singular], default: plural)
    }
}

// MARK: Self: Symbolic
extension SyntaxMap: Symbolic {
    public func localized(for context: Key) -> Value { self[context] }
}

// MARK: Self: Sendable
extension SyntaxMap: Sendable where Key: Sendable, Value: Sendable {}
