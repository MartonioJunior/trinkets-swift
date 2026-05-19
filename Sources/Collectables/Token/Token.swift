//
//  Token.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

/// Generic `Trinket` data structure that represents an in-game entry that doesn't represent any model
/// and with no associated data to itself.
/// 
/// A token is used to track quantities of a specified value in heterogeneous collections, as well as represent a dynamic entity.
public struct Token<ID: Hashable> {
    // MARK: Variables
    /// Identifier associated with this token.
    public let id: ID
    // MARK: Initializers
    /// Creates a new token.
    /// - Parameter tag: Symbol uniquely representing the token.
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
    // swiftlint:disable:next missing_docs
    public init(stringLiteral value: ID.StringLiteralType) {
        self.init(.init(stringLiteral: value))
    }
}

// MARK: Self: Hashable
extension Token: Hashable {}

// MARK: Self: Sendable
extension Token: Sendable where ID: Sendable {}

// MARK: Self: Trinket
extension Token: Trinket {}

// MARK: Self.ID: String
public extension Token where ID == String {
    /// Creates a token based on a static value.
    /// - Parameter string: Compile-time value.
    /// - Returns: A new `Token` instance.
    /// 
    /// Example:
    /// ```swift
    /// var coin: Token { .auto() } // Token "coin"
    /// ```
    static func auto(_ string: StaticString = #function) -> Self {
        .init(string.description)
    }
}
