//
//  MockInventory.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import Inventory
import TrinketsUnits

struct MockInventory {
    var contents: [MockItem.Measure]

    init(_ contents: some Sequence<MockItem.Measure>) {
        self.contents = contents.map(\.self)
    }
}

// MARK: Self: Catalogue
extension MockInventory: Catalogue {}

// MARK: Self: Dispenser
extension MockInventory: Dispenser {
    mutating func release(_ content: MockItem.Measure) -> MockItem.Measure? {
        guard let index = contents.firstIndex(where: { $0 == content }) else { return content }

        contents.remove(at: index)
        return nil
    }
}

// MARK: Self: Equatable
extension MockInventory: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
extension MockInventory: ExpressibleByArrayLiteral {}

// MARK: Self: Inventory
extension MockInventory: Inventory {
    typealias Contents = [MockItem.Measure]
    typealias Item = MockItem
}

// MARK: Self: Sendable
extension MockInventory: Sendable {}
