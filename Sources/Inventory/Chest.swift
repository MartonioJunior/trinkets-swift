//
//  Chest.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/11/2025.
//

import TrinketsUnits

/// Generic Inventory for storing items, providing a full-fledged inventory implementation.
/// - Item: What can be stored in the chest.
/// - Value: Type representing quantities of items in the chest.
/// 
/// ```swift
/// var chest = Chest {
///   50 * .currency(.coin);
///   .weapon(.soldierSword(.rare));
///   .key(.forestZone);
///   .star(.ddd, 1);
///   .star(.ttm, 5)
// }
/// ```
/// 
/// Can also be used as a building block with `@ItemBuilder` and `@InventoryBuilder`,
/// which allows for nested declarations.
public struct Chest<Item: Quantifiable & Equatable, Value: AdditiveArithmetic> {
    // MARK: Variables
    /// List of contents.
    var items: [Measurement<Item, Value>]
    /// Should measurements of the same item be stacked upon addition?
    var stack: Bool
    // MARK: Initializers
    /// Creates a new chest.
    /// - Parameters:
    ///   - stack: Should measurements of the same item be stacked upon addition?
    ///   - contents: List of contents.
    ///
    public init(
        stack: Bool = true,
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Value>] = { [] }
    ) {
        var items = [Measurement<Item, Value>]()

        for element in contents() {
            items.allocate(element, stacking: stack)
        }

        self.items = items
        self.stack = stack
    }
    // MARK: Methods
    /// Indices for entries of a given item.
    /// - Parameter item: Item to be checked against.
    /// - Returns: List of indices in relation to the chest's internal structure.
    private func indicesFor(_ item: Item) -> [Int] {
        items.indices.filter { items[$0].unit == item }
    }
}

// MARK: DotSyntax
public extension Chest {
    /// Creates a new chest with stacking enabled.
    /// - Parameter contents: List of contents.
    init(stacking contents: some Sequence<Measurement<Item, Value>>) {
        self.items = []
        self.stack = true

        for element in contents {
            items.allocate(element, stacking: true)
        }
    }
}

// MARK: Self: Catalogue
extension Chest: Catalogue where Value == Tally {
    // swiftlint:disable:next missing_docs
    public func fetch<T>(_ transform: (Measurement<Item, Value>) -> T?) -> [T] {
        items.compactMap(transform)
    }
}

// MARK: Self: Depot
extension Chest: Depot where Value == Tally {
    // swiftlint:disable:next missing_docs
    public mutating func store(_ content: Measurement<Item, Value>) -> Measurement<Item, Value>? {
        items.allocate(content, stacking: stack)
        return nil
    }
}

// MARK: Self: Dispenser
extension Chest: Dispenser where Value == Tally {
    // swiftlint:disable:next missing_docs
    public mutating func release(_ content: Measurement<Item, Value>) -> Measurement<Item, Value>? {
        switch content.value {
            case .nullify:
                return nil
            case .infinite:
                infiniteTally(on: indicesFor(content.unit))
                return nil
            case .fixed(let amount):
                let remainder = fixedTally(amount, on: indicesFor(content.unit))
                return remainder == 0 ? nil : content.unit.x(.fixed(remainder))
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
                    case .fixed(let a) where a > remainder:
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
extension Chest: ItemCollection where Value == Tally {
    // swiftlint:disable:next missing_docs
    public init(_ contents: some Sequence<Measurement<Item, Value>>) {
        self.items = contents.map(\.self)
        self.stack = false
    }
}

// MARK: Self: Inventory
extension Chest: Inventory where Value == Tally {
    // swiftlint:disable:next missing_docs
    public var contents: [Measurement<Item, Value>] { items }
}

// MARK: Self: Sendable
extension Chest: Sendable where Measurement<Item, Value>: Sendable {}

// MARK: Self.Item.Value: AdditiveArithmetic
public extension Chest where Value: AdditiveArithmetic {
    /// Reorganizes the internal contents of the chest to it's smallest size possible,
    /// stacking measurements of same items together into a minified form.
    mutating func optimize() {
        let queue: [Measurement<Item, Value>] = items
        items = []

        for element in queue {
            items.allocate(element, stacking: true)
        }
    }
}
