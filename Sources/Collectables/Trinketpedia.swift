//
//  Trinketpedia.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import IdentifiedCollections
import SwiftVariety

/// Data structure that contains a collection of heterogenous trinket entries for a given context
@dynamicMemberLookup
public struct Trinketpedia {
    public typealias ID = String
    public typealias Registry<T: Trinket> = IdentifiedArrayOf<T>

    // MARK: Variables
    var databases: HeterogeneousDictionary<ID>

    // MARK: Subscripts
    public subscript<T: Trinket>(_: T.Type) -> Registry<T> {
        get { (try? databases.fetch(T.registryKey)) ?? .init() }
        set { databases.registerOrUpdate(newValue, for: T.registryKey) }
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
    public init(_ databases: HeterogeneousDictionary<ID> = [:]) {
        self.databases = databases
    }

    // MARK: Methods
    public func fetch<T: Trinket>(id: T.ID) -> T? { self[T.self, id: id] }

    public mutating func register<T: Trinket>(_: T.Type = T.self, _ database: Registry<T>) {
        let key = T.registryKey

        do {
            var registry = try databases.fetch(key)
            registry.append(contentsOf: database)
            databases.registerOrUpdate(registry, for: key)
        } catch let error {
            switch error {
                case .invalidKey:
                    databases.registerOrUpdate(database, for: key)
                case .typeMismatch:
                    return
            }
        }
    }

    public mutating func removeDatabase<T: Trinket>(_: T.Type) {
        databases.remove(T.registryKey)
    }

    public mutating func removeAll() {
        databases.removeAll()
    }
}

// MARK: Self: Sendable
extension Trinketpedia: @unchecked Sendable {}
