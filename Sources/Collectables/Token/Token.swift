//
//  Token.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import TrinketsUnits

public struct Token<ID: Hashable, Value> {
    // MARK: Variables
    public let id: ID

    // MARK: Initializers
    public init(_ tag: ID) {
        self.id = tag
    }
}

// MARK: Self: Equatable
extension Token: Equatable {}

// MARK: Self: ExpressibleByStringLiteral
extension Token: ExpressibleByUnicodeScalarLiteral where ID: ExpressibleByStringLiteral {}
extension Token: ExpressibleByExtendedGraphemeClusterLiteral where ID: ExpressibleByStringLiteral {}
extension Token: ExpressibleByStringLiteral where ID: ExpressibleByStringLiteral {
    public init(stringLiteral value: ID.StringLiteralType) {
        self.init(.init(stringLiteral: value))
    }
}

// MARK: Self: Hashable
extension Token: Hashable {}

// MARK: Self: Measurable
extension Token: Measurable {}

// MARK: Self: Sendable
extension Token: Sendable where ID: Sendable {}

// MARK: Self: Trinket
extension Token: Trinket {}

// MARK: Self.ID: String
public extension Token where ID == String {
    static func auto(_ string: StaticString = #function) -> Self {
        .init(string.description)
    }
}
