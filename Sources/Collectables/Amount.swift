//
//  Amount.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

@dynamicMemberLookup
public struct Amount<Value> {
    @inlinable
    public subscript(dynamicMember member: String) -> Token<String, Value> {
        Self.of(member)
    }

    public init() {}

    @inlinable
    public static func of<Tag: Hashable>(_ tag: Tag) -> Token<Tag, Value> {
        .init(tag)
    }
}

// MARK: Self: Domain
extension Amount: Domain {
    public typealias Features = Void
}

// MARK: Self: Equatable
extension Amount: Equatable {}

// MARK: Self: Measurable
extension Amount: Measurable {}

// MARK: Self: Sendable
extension Amount: Sendable {}
