//
//  Inventory.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2025.
//

import TrinketsUnits

public protocol Inventory: ItemCollection {
    associatedtype Contents: Collection where Contents.Element == Measurement<Item, Value>
    typealias Value = Tally
    // MARK: Variables
    /// List of contents that the inventory has
    /// 
    /// It's recommended that the type returns an optimized table of contents with no repeats,
    /// whenever possible and considering the tradeoff between performance and collection size.
    var contents: Contents { get }
}

// MARK: Default Implementation
public extension Inventory {
    func mapValues(_ transform: (Value) -> Value) -> [Measurement<Item, Value>] {
        contents.map { $0.mapValue(transform) }
    }

    func union(@ItemBuilder<Item> with other: () -> [Measurement<Item, Value>]) -> [Measurement<Item, Value>] {
        contents + other()
    }

    static func * (lhs: Self, rhs: UInt) -> [Measurement<Item, Value>] {
        lhs.mapValues { $0 * rhs }
    }

    static func / (lhs: Self, rhs: UInt) -> [Measurement<Item, Value>] {
        lhs.mapValues { $0 / rhs }
    }
}

// MARK: Self.Builder
public typealias InventoryBuilder<I: Inventory> = ItemBuilder<I.Item>

// MARK: Self: Catalogue
public extension Inventory where Self: Catalogue {
    func fetch<T>(_ transform: (Measurement<Item, Value>) -> T?) -> [T] {
        contents.compactMap(transform)
    }
}

// MARK: Self: Dispenser
public extension Inventory where Self: Dispenser {
    @discardableResult
    mutating func transferAll<D: Depot>(to depot: inout D) -> [Measurement<Item, Value>] where D.Item == Item {
        let contents = contents.map(\.self)
        return transfer(to: &depot) { contents }
    }
}
