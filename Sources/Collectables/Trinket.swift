//
//  Trinket.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/09/2025.
//

public protocol Trinket<ID>: Identifiable {
    static var trinketpediaID: Trinketpedia.ID { get }
}

// MARK: Default Implementation
public extension Trinket {
    static var trinketpediaID: Trinketpedia.ID { "\(Self.self)" }
}

// MARK: Sequence (EX)
public extension Sequence where Element == any Trinket {
    subscript<T: Trinket>(_: T.Type = T.self) -> [T] {
        compactMap { $0 as? T }
    }
}

public extension Sequence where Element: Trinket {
    subscript(_ key: TrinketKey<Element>) -> [Element] {
        filter { $0.id == key.referenceID }
    }

    subscript(id id: Element.ID) -> [Element] {
        filter { $0.id == id }
    }

    subscript(_ item: Element) -> [Element] where Element: Equatable {
        filter { $0 == item }
    }
}
