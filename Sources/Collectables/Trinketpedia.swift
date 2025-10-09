//
//  Trinketpedia.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

/// Data structure that contains a collection of heterogenous trinket entries for a given context
@dynamicMemberLookup
public struct Trinketpedia {
    public typealias ID = String
    public typealias Registry<T: Trinket> = TrinketRegistry<T>

    // MARK: Variables
    var databases: [ID: Any] = [:]

    // MARK: Subscripts
    subscript<T: Trinket>(_: T.Type) -> Registry<T> {
        get { databases[T.trinketpediaID] as? Registry<T> ?? .init() }
        set { databases[T.trinketpediaID] = newValue }
    }

    subscript<T: Trinket>(_: T.Type = T.self, id id: T.ID) -> T? {
        self[T.self][id: id]
    }

    subscript<T: Trinket>(dynamicMember member: String) -> T? where T.ID == String {
        self[T.self, id: member]
    }

    subscript<T: Trinket>(key: TrinketKey<T>) -> T? {
        self[T.self, id: key.referenceID]
    }

    // MARK: Initializers
    public init() {}

    // MARK: Methods
    func fetch<T: Trinket>(id: T.ID) -> T? { self[T.self, id: id] }

    mutating func register<T: Trinket>(_: T.Type = T.self, _ database: Registry<T>) {
        let key = T.trinketpediaID

        if databases.keys.contains(key), var registry = databases[key] as? Registry<T> {
            database.entries.forEach { _ = registry.register($0) }
            databases[key] = registry
        } else {
            databases[key] = database
        }
    }

    mutating func removeDatabase<T: Trinket>(_: T.Type) {
        databases.removeValue(forKey: T.trinketpediaID)
    }

    mutating func removeAll() {
        databases.removeAll()
    }
}

// MARK: Self: Sendable
extension Trinketpedia: @unchecked Sendable {}
