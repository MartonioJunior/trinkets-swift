//
//  ItemCollection.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

public protocol ItemCollection {
    associatedtype Item: Measurable
    /// Instances the storage with an existing list of contents
    /// - Parameter contents: Contents of the inventory
    init(_ contents: some Sequence<Measurement<Item, Tally>>)
}

// MARK: Default Implementation
public extension ItemCollection {
    init() { self.init([]) }

    init(@ItemBuilder<Item> _ elements: () -> [Measurement<Item, Tally>]) {
        self.init(elements())
    }
}

// MARK: Self: ExpressibleByArrayLiteral
public extension ItemCollection where Self: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Measurement<Item, Tally>...) {
        self.init(elements)
    }
}
