//
//  Catalogue.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

public protocol Catalogue {
    associatedtype Item: Measurable

    func fetch<T>(_ transform: (Measurement<Item, Tally>) -> T?) -> [T]
    func has(_ content: Measurement<Item, Tally>) -> Bool
}

// MARK: Default Implementation
public extension Catalogue {
    func fetch(where predicate: (Measurement<Item, Tally>) -> Bool) -> [Measurement<Item, Tally>] {
        fetch { predicate($0) ? $0 : nil }
    }

    func fetchByItem(_ transform: (Item) -> Item?) -> [Measurement<Item, Tally>] {
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
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> Bool {
        contents().allSatisfy { has($0) }
    }

    func intersection(
        @ItemBuilder<Item> with other: () -> [Measurement<Item, Tally>],
        overlap: (Measurement<Item, Tally>, Measurement<Item, Tally>) -> Measurement<Item, Tally>?,
        compose: ([Measurement<Item, Tally>]) -> Measurement<Item, Tally>? = \.first
    ) -> [Measurement<Item, Tally>] {
        let otherContents = other()

        return otherContents.compactMap { other in
            let results = fetch { element in
                overlap(element, other)
            }
            return compose(results)
        }
    }

    func uniqueAgainst(
        @ItemBuilder<Item> _ other: () -> [Measurement<Item, Tally>],
        check: (Measurement<Item, Tally>, Measurement<Item, Tally>) -> Bool
    ) -> [Measurement<Item, Tally>] {
        let other = other()

        return fetch { item in
            !other.contains { otherItem in
                check(item, otherItem)
            }
        }
    }

    func uniqueNotIn(
        @ItemBuilder<Item> _ other: () -> [Measurement<Item, Tally>],
        equals: (Item, Item) -> Bool
    ) -> [Measurement<Item, Tally>] {
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
    mutating func releaseAll() -> [Measurement<Item, Tally>] {
        releaseAll { _ in true }
    }

    mutating func releaseAll(
        where predicate: (Measurement<Item, Tally>) -> Bool
    ) -> [Measurement<Item, Tally>] {
        let forRemoval = fetch(where: predicate)
        return release { forRemoval }
    }
}

// MARK: Self.Item: Comparable
public extension Catalogue where Item: Comparable {
    func intersection(
        @ItemBuilder<Item> with other: () -> [Measurement<Item, Tally>],
        compose: ([Measurement<Item, Tally>]) -> Measurement<Item, Tally>? = \.first
    ) -> [Measurement<Item, Tally>] {
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
    func has(_ content: Measurement<Item, Tally>) -> Bool {
        has(content.value) { $0 == content.unit ? $0 : nil }
    }

    func lacking(
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> Bool {
        !contents().allSatisfy { has($0) }
    }

    func uniqueNotIn(
        @ItemBuilder<Item> _ other: () -> [Measurement<Item, Tally>]
    ) -> [Measurement<Item, Tally>] {
        uniqueNotIn(other, equals: ==)
    }
}
