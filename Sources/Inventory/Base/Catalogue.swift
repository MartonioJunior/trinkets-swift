//
//  Catalogue.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

public protocol Catalogue {
    associatedtype Item: Measurable where Item.Value == Tally

    func fetch<T>(_ transform: (Item.Measure) -> T?) -> [T]
    func has(_ content: Item.Measure) -> Bool
}

// MARK: Default Implementation
public extension Catalogue {
    func fetch(where predicate: (Item.Measure) -> Bool) -> [Item.Measure] {
        fetch { predicate($0) ? $0 : nil }
    }

    func fetchByItem(_ transform: (Item) -> Item?) -> [Item.Measure] {
        fetch {
            guard let item = transform($0.unit) else { return nil }

            return item.x($0.value)
        }
    }
    /// Checks if an inventory has enough supply for a given criteria
    /// - Parameters:
    ///   - tally: How much is required to pass the check
    ///   - transform: How should stock be counted?
    ///
    /// - Returns:
    ///   - `true` when the inventory can supply that
    ///   - `false` when the inventory cannot supply it
    func has(
        _ tally: Tally,
        _ transform: (Item) -> Item?
    ) -> Bool {
        fetchByItem(transform).has(tally)
    }

    func has(
        @ItemBuilder<Item> _ contents: () -> [Item.Measure]
    ) -> Bool {
        contents().allSatisfy { has($0) }
    }

    func intersection(
        @ItemBuilder<Item> with other: () -> [Item.Measure],
        overlap: (Item.Measure, Item.Measure) -> Item.Measure?,
        compose: ([Item.Measure]) -> Item.Measure? = \.first
    ) -> [Item.Measure] {
        let otherContents = other()

        return otherContents.compactMap { other in
            let results = fetch { element in
                overlap(element, other)
            }
            return compose(results)
        }
    }

    func uniqueAgainst(
        @ItemBuilder<Item> _ other: () -> [Item.Measure],
        check: (Item.Measure, Item.Measure) -> Bool
    ) -> [Item.Measure] {
        let other = other()

        return fetch { item in
            !other.contains { otherItem in
                check(item, otherItem)
            }
        }
    }

    func uniqueNotIn(
        @ItemBuilder<Item> _ other: () -> [Item.Measure],
        equals: (Item, Item) -> Bool
    ) -> [Item.Measure] {
        let other = other()

        return fetch { lhs in
            !other.contains { rhs in
                equals(lhs.unit, rhs.unit)
            }
        }
    }
}

// MARK: Self: Dispenser
public extension Catalogue where Self: Dispenser {
    mutating func releaseAll() -> [Item.Measure] {
        releaseAll { _ in true }
    }

    mutating func releaseAll(
        where predicate: (Item.Measure) -> Bool
    ) -> [Item.Measure] {
        let forRemoval = fetch(where: predicate)
        return release { forRemoval }
    }
}

// MARK: Self.Item: Comparable
public extension Catalogue where Item: Comparable {
    func intersection(
        @ItemBuilder<Item> with other: () -> [Item.Measure],
        compose: ([Item.Measure]) -> Item.Measure? = \.first
    ) -> [Item.Measure] {
        intersection(with: other, overlap: {
            guard $0.unit == $1.unit else { return nil }

            let minimum = min($0.value, $1.value)
            return switch minimum {
                case .value(0), .nullify:
                    nil
                default:
                    $0.unit.x(minimum)
            }
        }, compose: compose)
    }
}

// MARK: Self.Item: Equatable
public extension Catalogue where Item: Equatable {
    func has(_ content: Item.Measure) -> Bool {
        has(content.value) { $0 == content.unit ? $0 : nil }
    }

    func lacking(
        @ItemBuilder<Item> _ contents: () -> [Item.Measure]
    ) -> Bool {
        !contents().allSatisfy { has($0) }
    }

    func uniqueNotIn(
        @ItemBuilder<Item> _ other: () -> [Item.Measure]
    ) -> [Item.Measure] {
        uniqueNotIn(other, equals: ==)
    }
}
