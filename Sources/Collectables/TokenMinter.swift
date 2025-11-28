//
//  TokenMinter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

@dynamicMemberLookup
public struct TokenMinter<Value> {
    @inlinable
    public subscript(dynamicMember member: String) -> Token<String, Value> {
        Self.mint(member)
    }

    public init() {}

    @inlinable
    public static func mint<Tag: Hashable>(_ tag: Tag) -> Token<Tag, Value> {
        .init(tag)
    }
}

// MARK: Self: Equatable
extension TokenMinter: Equatable {}

// MARK: Self: Sendable
extension TokenMinter: Sendable {}

// MARK: Token (EX)
public extension Token {
    typealias Minter = TokenMinter<Value>

    static func minting(_: Value.Type = Value.self) -> Minter { .init() }
}
