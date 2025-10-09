//
//  TrinketKey.swift
//  Trinkets
//
//  Created by Martônio Júnior on 20/09/2025.
//

/// Identifier that uniquely references a Trinket within the scope of a game
public struct TrinketKey<T: Trinket> {
    // MARK: Variables
    var referenceID: T.ID

    // MARK: Initializers
    public init(_ id: T.ID, _: T.Type = T.self) {
        self.referenceID = id
    }
}

// MARK: Self: CustomStringConvertible
extension TrinketKey: CustomStringConvertible {
    public var description: String { "\(T.trinketpediaID)#\(referenceID)" }
}

// MARK: Self: Equatable
extension TrinketKey: Equatable where T.ID: Equatable {}

// MARK: Self: ExpressibleByStringLiteral
extension TrinketKey: ExpressibleByUnicodeScalarLiteral where T.ID: ExpressibleByStringLiteral {}
extension TrinketKey: ExpressibleByExtendedGraphemeClusterLiteral where T.ID: ExpressibleByStringLiteral {}
extension TrinketKey: ExpressibleByStringLiteral where T.ID: ExpressibleByStringLiteral {
    public init(stringLiteral value: T.ID.StringLiteralType) {
        self.referenceID = .init(stringLiteral: value)
    }
}

// MARK: Self: Hashable
extension TrinketKey: Hashable where T.ID: Hashable {}

// MARK: Self: Sendable
extension TrinketKey: Sendable where T.ID: Sendable {}

// MARK: Self.ID == String
public extension TrinketKey {}

// MARK: Trinket (EX)
public extension Trinket {
    typealias Key = TrinketKey<Self>

    var key: Key { .init(id, Self.self) }
}
