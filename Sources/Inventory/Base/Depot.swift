//
//  Depot.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

public protocol Depot<Item> {
    associatedtype Item: Measurable where Item.Value == Tally
    /// Stores items for later use
    /// - Parameter content: How many items to add to storage
    /// - Returns: The remaining amount that was not collected, `nil` if all items got added
    mutating func store(_ content: Item.Measure) -> Item.Measure?
}

// MARK: Default Implementation
public extension Depot {
    /// Collects a list of items and adds it into the depot
    /// - Parameters:
    ///   - contents: List of items collected
    ///
    /// - Returns: The remainder stock not added in.
    mutating func store(
        @ItemBuilder<Item> _ contents: () -> [Item.Measure]
    ) -> [Item.Measure] {
        contents().compactMap { self.store($0) }
    }

    static func += (lhs: inout Self, rhs: Item.Measure) {
        _ = lhs.store(rhs)
    }
}
