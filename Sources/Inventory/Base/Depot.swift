//
//  Depot.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits
/// Type that can store items.
/// 
/// Can be a slot, container or a feature of the inventory.
/// 
/// Concrete implementations are responsible for handling allocation of items.
public protocol Depot<Item> {
    /// Type of item accepted by this depot.
    associatedtype Item: Measurable
    /// Stores items for later use.
    /// - Parameter content: How many items to add to storage.
    /// - Returns: The remaining amount that was not collected, `nil` if all items got added.
    /// 
    /// Content may be not stored in cases where the item is unable to.
    mutating func store(_ content: Measurement<Item, Tally>) -> Measurement<Item, Tally>?
}

// MARK: Default Implementation
public extension Depot {
    /// Collects a list of items and adds it into the depot.
    /// - Parameters:
    ///   - contents: List of items collected.
    ///
    /// - Returns: The remainder stock not added in.
    /// 
    /// Example:
    /// ```swift
    /// inventory.store {
    ///   coin.x(25)
    ///   keyItem
    /// }
    /// ```
    mutating func store(
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> [Measurement<Item, Tally>] {
        contents().compactMap { self.store($0) }
    }
    /// Collects an amount of item into the inventory.
    /// - Parameters:
    ///   - lhs: Depot to be mutated.
    ///   - rhs: Measurement of item to be stored.
    ///
    /// This operation discards the remainder not added in.
    static func += (lhs: inout Self, rhs: Measurement<Item, Tally>) {
        _ = lhs.store(rhs)
    }
}
