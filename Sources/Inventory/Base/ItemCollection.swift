//
//  ItemCollection.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

public protocol ItemCollection {
    associatedtype Item: Measurable where Item.Value == Tally
    /// Instances the storage with an existing list of contents
    /// - Parameter contents: Contents of the inventory
    init(_ contents: some Sequence<Item.Measure>)
}

// MARK: Default Implementation
public extension ItemCollection {
    init() { self.init([]) }

    init(@ItemBuilder<Item> _ elements: () -> [Item.Measure]) {
        self.init(elements())
    }
}

// MARK: Self: ExpressibleByArrayLiteral
public extension ItemCollection where Self: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Item.Measure...) {
        self.init(elements)
    }
}
