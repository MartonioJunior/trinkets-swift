//
//  Trinketpedia.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import IdentifiedCollections

/// Data structure that contains a collection of heterogenous trinket entries for a given context
@dynamicMemberLookup
public struct Trinketpedia {
    public typealias ID = String
    public typealias Registry<T: Trinket> = IdentifiedArrayOf<T>

    // MARK: Variables
    var databases: [ID: Any] = [:]

    // MARK: Subscripts
    public subscript<T: Trinket>(_: T.Type) -> Registry<T> {
        get { databases[T.trinketpediaID] as? Registry<T> ?? .init() }
        set { databases[T.trinketpediaID] = newValue }
    }

    public subscript<T: Trinket>(_: T.Type = T.self, id id: T.ID) -> T? {
        self[T.self][id: id]
    }

    public subscript<T: Trinket>(dynamicMember member: String) -> T? where T.ID == String {
        self[T.self, id: member]
    }

    public subscript<T: Trinket>(key: TrinketKey<T>) -> T? {
        self[T.self, id: key.id]
    }

    // MARK: Initializers
    public init() {}

    // MARK: Methods
    public func fetch<T: Trinket>(id: T.ID) -> T? { self[T.self, id: id] }

    public mutating func register<T: Trinket>(_: T.Type = T.self, _ database: Registry<T>) {
        let key = T.trinketpediaID

        if databases.keys.contains(key), var registry = databases[key] as? Registry<T> {
            registry.append(contentsOf: database)
            databases[key] = registry
        } else {
            databases[key] = database
        }
    }

    public mutating func removeDatabase<T: Trinket>(_: T.Type) {
        databases.removeValue(forKey: T.trinketpediaID)
    }

    public mutating func removeAll() {
        databases.removeAll()
    }
}

// MARK: Self: Sendable
extension Trinketpedia: @unchecked Sendable {}
