//
//  Chest.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/11/2025.
//

import TrinketsUnits

public struct Chest<Item: Measurable & Equatable> where Item.Value: AdditiveArithmetic {
    // MARK: Variables
    var items: [Item.Measure]
    var stack: Bool

    // MARK: Initializers
    public init(
        stack: Bool = true,
        @ItemBuilder<Item> _ contents: () -> [Item.Measure]
    ) {
        var items = [Item.Measure]()

        for element in contents() {
            items.allocate(element, stacking: stack)
        }

        self.items = items
        self.stack = stack
    }

    // MARK: Methods
    private func indicesFor(_ item: Item) -> [Int] {
        items.indices.filter { items[$0].unit == item }
    }
}

// MARK: Self: Catalogue
extension Chest: Catalogue where Item.Value == Tally {
    public func fetch<T>(_ transform: (Item.Measure) -> T?) -> [T] {
        items.compactMap(transform)
    }
}

// MARK: Self: Depot
extension Chest: Depot where Item.Value == Tally {
    public mutating func store(_ content: Item.Measure) -> Item.Measure? {
        items.allocate(content, stacking: stack)
        return nil
    }
}

// MARK: Self: Dispenser
extension Chest: Dispenser where Item.Value == Tally {
    public mutating func release(_ content: Item.Measure) -> Item.Measure? {
        switch content.value {
            case .nullify:
                return nil
            case .infinite:
                infiniteTally(on: indicesFor(content.unit))
                return nil
            case .value(let amount):
                let remainder = fixedTally(amount, on: indicesFor(content.unit))
                return remainder == 0 ? nil : content.unit.x(.value(remainder))
        }

        func infiniteTally(on indices: [Int]) {
            for i in indices.reversed() {
                let stock = items.remove(at: i)

                if stock.value == .infinite { break }
            }
        }

        func fixedTally(_ amount: Tally.Value, on indices: [Int]) -> UInt {
            var remainder: UInt = amount

            for i in indices.reversed() {
                let stock = items[i]

                switch stock.value {
                    case .value(let a) where a > remainder:
                        items[i].value -= remainder
                        return 0
                    case .infinite:
                        return 0
                    default:
                        remainder -= items.remove(at: i).value.amount
                        continue
                }
            }

            return remainder
        }
    }
}

// MARK: Self: Equatable
extension Chest: Equatable {}

// MARK: Self: ItemCollection
extension Chest: ItemCollection where Item.Value == Tally {
    public init(_ contents: some Sequence<Item.Measure>) {
        self.items = contents.map(\.self)
        self.stack = false
    }
}

// MARK: Self: Inventory
extension Chest: Inventory where Item.Value == Tally {
    public var contents: [Item.Measure] { items }
}

// MARK: Self: Sendable
extension Chest: Sendable where Item.Measure: Sendable {}

// MARK: Self.Item.Value: AdditiveArithmetic
public extension Chest where Item.Value: AdditiveArithmetic {
    mutating func optimize() {
        let queue: [Item.Measure] = items
        items = []

        for element in queue {
            items.allocate(element, stacking: true)
        }
    }
}
