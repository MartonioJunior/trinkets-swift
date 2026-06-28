//
//  Dispenser.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

/// Type that can release items.
/// 
/// Can be a slot, container or a feature of the inventory.
public protocol Dispenser<Item> {
    /// Type of item that can be released.
    associatedtype Item: Quantifiable
    /// Removes items from the storage.
    /// - Parameter content: How many items to remove from storage
    /// - Returns: The remaining amount that was not discarded, `nil` if all items got removed
    mutating func release(_ content: Measurement<Item, Tally>) -> Measurement<Item, Tally>?
}

// MARK: Default Implementation
public extension Dispenser {
    /// Releases the items from the dispenser
    /// - Parameters:
    ///   - contents: List of items to be discarded
    ///
    /// - Returns: The remainder stock not removed.
    /// 
    /// Example:
    /// ```swift
    /// inventory.release {
    ///   starShards.x(250)
    ///   lostKey
    /// }
    /// ```
    mutating func release(
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> [Measurement<Item, Tally>] {
        contents().compactMap { self.release($0) }
    }
    /// Moves items from this dispenser to a depot.
    /// - Parameters:
    ///   - depot: Depot that will receive the items.
    ///   - contents: List of contents to be transferred.
    ///
    /// - Returns: Remainder of the transfer operation.
    /// 
    /// Example:
    /// ```swift
    /// inventory.transfer(to: &drawPile) {
    ///   5 * coins
    /// }
    /// ```
    @discardableResult
    mutating func transfer<D: Depot>(
        to depot: inout D,
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> [Measurement<Item, Tally>] where D.Item == Item {
        contents().compactMap {
            let remainderRelease = release($0)?.value ?? .zero
            let stockToStore = $0.value - remainderRelease

            guard stockToStore.inStock else { return $0 }

            return if let remainderStock = depot.store($0.unit.x(stockToStore)) {
                remainderStock.unit.x(remainderStock.value + remainderRelease)
            } else {
                nil
            }
        }
    }
    /// Removes items from the storage.
    /// - Parameters:
    ///   - lhs: Dispenser to be mutated.
    ///   - rhs: Measurement of item to be released.
    ///
    static func -= (lhs: inout Self, rhs: Measurement<Item, Tally>) {
        _ = lhs.release(rhs)
    }
}
