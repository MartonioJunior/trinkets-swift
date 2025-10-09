//
//  TrinketRegistry.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@dynamicMemberLookup
public struct TrinketRegistry<Entry: Trinket> {
    // MARK: Variables
    var contents: [Entry.ID: Entry]

    var entries: [Entry.ID: Entry].Values { contents.values }

    // MARK: Subscripts
    subscript(id id: Entry.ID) -> Entry? { contents[id] }

    subscript(dynamicMember member: String) -> Entry? where Entry.ID == String {
        self[id: member]
    }

    subscript(key: Entry.Key) -> Entry? {
        self[id: key.referenceID]
    }

    // MARK: Initializers
    init(_ elements: some Sequence<Entry>) {
        self.contents = .init(uniqueKeysWithValues: elements.map { ($0.id, $0) })
    }

    // MARK: Methods
    mutating func register(_ entry: Entry) -> Bool {
        if contents.keys.contains(entry.id) { return false }

        contents[entry.id] = entry
        return true
    }

    mutating func removeEntry(by id: Entry.ID) {
        contents.removeValue(forKey: id)
    }
}

// MARK: Self: Equatable
extension TrinketRegistry: Equatable where Entry: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
extension TrinketRegistry: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Entry...) {
        self.init(elements)
    }
}

// MARK: Self: Sendable
extension TrinketRegistry: Sendable where Entry: Sendable, Entry.ID: Sendable {}

// MARK: Self.Entry: CaseIterable
extension TrinketRegistry where Entry: CaseIterable {
    static var allEntries: Self { .init(Entry.allCases.map(\.self)) }
}

// MARK: Trinket (EX)
public extension Trinket {
    typealias Registry = TrinketRegistry<Self>
}
