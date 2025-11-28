//
//  IDKey.swift
//  Trinkets
//
//  Created by Martônio Júnior on 20/09/2025.
//

/// Identifier that uniquely references a Trinket within the scope of a game
public typealias TrinketKey<T: Trinket> = IDKey<T.ID, T>

@dynamicMemberLookup
public struct IDKey<ID, Value> {
    // MARK: Variables
    var referenceID: ID

    var typeID: ObjectIdentifier { .init(Value.self) }

    // MARK: Initializers
    public init(_ id: ID, _: Value.Type = Value.self) {
        self.referenceID = id
    }
}

// MARK: Self: CustomStringConvertible
extension IDKey: CustomStringConvertible {
    public var description: String { "\(Value.self)#\(referenceID)" }
}

// MARK: Self: Equatable
extension IDKey: Equatable where ID: Equatable {}

// MARK: Self: ExpressibleByStringLiteral
extension IDKey: ExpressibleByUnicodeScalarLiteral where ID: ExpressibleByStringLiteral {}
extension IDKey: ExpressibleByExtendedGraphemeClusterLiteral where ID: ExpressibleByStringLiteral {}
extension IDKey: ExpressibleByStringLiteral where ID: ExpressibleByStringLiteral {
    public init(stringLiteral value: ID.StringLiteralType) {
        self.referenceID = .init(stringLiteral: value)
    }
}

// MARK: Self: Hashable
extension IDKey: Hashable where ID: Hashable {}

// MARK: Self: Sendable
extension IDKey: Sendable where ID: Sendable {}

// MARK: ID == String
public extension IDKey where ID == String {
    static subscript(dynamicMember member: ID) -> Self {
        .init(member)
    }
}

// MARK: Value: Identifiable
public extension IDKey where Value: Identifiable, ID == Value.ID {
    init(_ value: Value) where Value: Identifiable, ID == Value.ID {
        self.referenceID = value.id
    }
}

// MARK: Trinkets (EX)
public extension Trinket {
    typealias Key = IDKey<ID, Self>

    var key: Key { .init(id, Self.self) }
}
