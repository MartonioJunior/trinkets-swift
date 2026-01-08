//
//  Inventory.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2025.
//

import TrinketsUnits

public protocol Inventory: ItemCollection {
    // MARK: Aliases
    associatedtype Contents: Collection where Contents.Element == Item.Measure
    // MARK: Variables
    /// List of contents that the inventory has
    /// 
    /// It's recommended that the type returns an optimized table of contents with no repeats,
    /// whenever possible and considering the tradeoff between performance and collection size.
    var contents: Contents { get }
}

// MARK: Default Implementation
public extension Inventory {
    func mapValues(_ transform: (Item.Value) -> Item.Value) -> [Item.Measure] {
        contents.map { $0.map(transform) }
    }

    func union(@ItemBuilder<Item> with other: () -> [Item.Measure]) -> [Item.Measure] {
        contents + other()
    }

    static func * (lhs: Self, rhs: UInt) -> [Item.Measure] {
        lhs.mapValues { $0 * rhs }
    }

    static func / (lhs: Self, rhs: UInt) -> [Item.Measure] {
        lhs.mapValues { $0 / rhs }
    }
}

// MARK: Self.Builder
public typealias InventoryBuilder<I: Inventory> = ItemBuilder<I.Item>

// MARK: Self: Catalogue
public extension Inventory where Self: Catalogue {
    func fetch<T>(_ transform: (Item.Measure) -> T?) -> [T] {
        contents.compactMap(transform)
    }
}

// MARK: Self: Dispenser
public extension Inventory where Self: Dispenser {
    @discardableResult
    mutating func transferAll<D: Depot>(to depot: inout D) -> [Item.Measure] where D.Item == Item {
        let contents = contents.map(\.self)
        return transfer(to: &depot) { contents }
    }
}
