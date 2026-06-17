//
//  Inventory.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2025.
//

import TrinketsUnits

/// Collection of items that can be described off a list of contents.
public protocol Inventory: ItemCollection {
    /// Type representing the table of contents of an inventory.
    /// 
    /// While this can be the internal storage structure, it's recommended to keep that
    /// separate from the storage as it's meant for declarative consumption.
    associatedtype Contents: Collection where Contents.Element == Measurement<Item, Value>
    /// Type of quantity used to track item amounts.
    typealias Value = Tally
    // MARK: Variables
    /// Table of contents that the inventory has.
    /// 
    /// It's recommended that the type returns an optimized table of contents with no repeats,
    /// whenever possible and considering the tradeoff between performance and collection size.
    var contents: Contents { get }
}

// MARK: Default Implementation
public extension Inventory {
    /// Transforms the values in the list of contents presented by the inventory.
    /// - Parameter transform: Mapping function for values.
    /// - Returns: List of contents with transformed values.
    /// 
    /// Example
    /// ```swift
    /// let doubleStock = inventory.mapValues { $0 * 2 }
    /// ```
    func mapValues(_ transform: (Value) -> Value) -> [Measurement<Item, Value>] {
        contents.map { $0.mapValue(transform) }
    }
    /// Returns the combined list of contents of the inventory with other sources.
    /// - Parameter other: List of contents to combine with.
    /// - Returns: Combined list of contents.
    func union(@ItemBuilder<Item> with other: () -> [Measurement<Item, Value>]) -> [Measurement<Item, Value>] {
        contents + other()
    }
    /// Returns the list of contents of the inventory multiplied by a given amount.
    /// - Parameters:
    ///   - lhs: Inventory.
    ///   - rhs: Amount to multiply as.
    ///
    /// - Returns: List of contents of inventory multiplied by value.
    static func * (lhs: Self, rhs: UInt) -> [Measurement<Item, Value>] {
        lhs.mapValues { $0 * rhs }
    }
    /// Returns the list of contents of the inventory divided by a given amount.
    /// - Parameters:
    ///   - lhs: Inventory.
    ///   - rhs: Amount to divide as.
    ///
    /// - Returns: List of contents of inventory divided by value.
    static func / (lhs: Self, rhs: UInt) -> [Measurement<Item, Value>] {
        lhs.mapValues { $0 / rhs }
    }
}

// MARK: Self.Builder
/// Builder used to compose items inside of inventories.
public typealias InventoryBuilder<I: Inventory> = ItemBuilder<I.Item>

// MARK: Self: Catalogue
public extension Inventory where Self: Catalogue {
    /// Fetches the stock entries into a well-defined type.
    /// - Parameter transform:  Transformation function of a stock into `T`.
    /// - Returns: Results of the query, as a `[T]` instance.
    func fetch<T>(_ transform: (Measurement<Item, Value>) -> T?) -> [T] {
        contents.compactMap(transform)
    }
}

// MARK: Self: Dispenser
public extension Inventory where Self: Dispenser {
    /// Moves all contents from the inventory to a specified depot.
    /// - Parameter depot: Depot that will receive the contents.
    /// - Returns: Remainder removed from the inventory that wasn't added to the depot.
    @discardableResult
    mutating func transferAll<D: Depot>(to depot: inout D) -> [Measurement<Item, Value>] where D.Item == Item {
        let contents = contents.map(\.self)
        return transfer(to: &depot) { contents }
    }
}
