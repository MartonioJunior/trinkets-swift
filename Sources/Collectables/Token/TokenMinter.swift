//
//  TokenMinter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

/// Middleware data structure used as a way to dynamically create tokens on-demand.
@dynamicMemberLookup
public struct TokenMinter {
    /// Creates a new token.
    /// - Parameter member: Identifier for the token.
    /// - Returns: A new `Token` instance.
    @inlinable
    public static subscript(dynamicMember member: String) -> Token<String> {
        .init(member)
    }
    /// Creates a new factory of tokens.
    public init() {}
    /// Creates a new token.
    /// - Parameter tag: Identifier for the token.
    /// - Returns: A new `Token` instance.
    @inlinable
    public func mint<Tag: Hashable>(_ tag: Tag) -> Token<Tag> {
        .init(tag)
    }
}

// MARK: Self: Equatable
extension TokenMinter: Equatable {}

// MARK: Self: Sendable
extension TokenMinter: Sendable {}

// MARK: Token (EX)
public extension Token {
    /// Factory for dynamically instancing tokens.
    typealias Minter = TokenMinter
    /// Creates a new factory of tokens.
    /// 
    /// Works as a DotSyntax solution for quickly creating token instances:
    /// ```swift
    /// let token: Token = .minting.energy
    /// ```
    static var minting: Minter.Type { Minter.self }
}
