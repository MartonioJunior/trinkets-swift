//
//  Trinket.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/09/2025.
//

import SwiftVariety

/// Identifier that uniquely references a Trinket within the scope of a game
public typealias TrinketKey<T: Trinket> = HeterogeneousKey<T.ID, T>
/// In-game data model that represents something that can be obtained in the game that is uniquely identifiable.
/// 
/// Multiple trinket instances can share the same ID.
/// 
/// Examples:
/// ```swift
/// let rock = Material("rock")
/// let bossKey = BossKey.forestTemple
/// let ttm5 = Star.ttm(5)
/// let ddd1: Star = .ddd(1)
/// let currency: Currency = .coin
/// ```
public protocol Trinket<ID>: Identifiable {
    /// Identifier associated with the trinket type.
    static var trinketpediaID: Trinketpedia.ID { get }
}

// MARK: Default Implementation
public extension Trinket {
    // swiftlint:disable:next missing_docs
    static var trinketpediaID: Trinketpedia.ID { "\(Self.self)" }
}

// MARK: Self.Key
public extension Trinket {
    /// Alias for a `TrinketKey`
    typealias Key = TrinketKey<Self>
    /// Key used to access this trinket in any heterogeneous collection.
    var key: TrinketKey<Self> { .init(id) }
}

// MARK: Sequence (EX)
public extension Sequence where Element == any Trinket {
    /// Queries for all trinkets of a certain type.
    /// - Returns: List with all trinkets of type `T`.
    subscript<T: Trinket>(_: T.Type = T.self) -> [T] {
        compactMap { $0 as? T }
    }
}

public extension Sequence where Element: Trinket {
    /// Queries for all elements that share an ID with a Trinket Key.
    /// - Parameter key: Key used.
    /// - Returns: A list of trinkets with the given id in `key`.
    /// 
    /// Example:
    /// ```swift
    /// swords[.flameSword]
    /// ```
    subscript(_ key: TrinketKey<Element>) -> [Element] {
        filter { $0.id == key.id }
    }
    /// Obtains all elements with a given ID.
    /// - Parameter id: Identifier for the Trinket.
    /// - Returns:
    subscript(id id: Element.ID) -> [Element] {
        filter { $0.id == id }
    }
    /// Returns all trinkets that are exactly the same as this one.
    /// - Parameter item: Trinket to evaluate.
    /// - Returns: List of trinkets equal to `item`.
    @available(*, deprecated, message: "Use `contains(_:)` instead.")
    subscript(_ item: Element) -> [Element] where Element: Equatable {
        filter { $0 == item }
    }
}
