//
//  Dispenser.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

public protocol Dispenser<Item> {
    associatedtype Item: Measurable
    /// Removes items from the component
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
    mutating func release(
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> [Measurement<Item, Tally>] {
        contents().compactMap { self.release($0) }
    }

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

    static func -= (lhs: inout Self, rhs: Measurement<Item, Tally>) {
        _ = lhs.release(rhs)
    }
}
