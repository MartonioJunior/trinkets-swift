//
//  Catalogue.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

/// Type that can query information about items.
public protocol Catalogue {
    /// Type of item that can be queried.
    associatedtype Item: Measurable
    /// Fetches the stock entries into a well-defined type.
    /// - Parameter transform: Transformation function of a stock into `T`.
    /// - Returns: Results of the query, as a `[T]` instance.
    func fetch<T>(_ transform: (Measurement<Item, Tally>) -> T?) -> [T]
    /// Checks whether the catalogue has enough of an item.
    /// - Parameter content: Amount of item required.
    /// - Returns: `true` when the catalogue has enough stock, `false` otherwise.
    func has(_ content: Measurement<Item, Tally>) -> Bool
}

// MARK: Default Implementation
public extension Catalogue {
    /// Fetches the stock entries based on a predicate.
    /// - Parameter predicate: Predicate of the query.
    /// - Returns: Stock entries that conform to `predicate`.
    func fetch(where predicate: (Measurement<Item, Tally>) -> Bool) -> [Measurement<Item, Tally>] {
        fetch { predicate($0) ? $0 : nil }
    }
    /// Fetches the stock entries based on item transformation.
    /// - Parameter transform: Compact transformation for items.
    /// - Returns: Stock entries that return valid items after transformation.
    /// 
    /// Can be used together with enum case paths for a more declarative solution:
    /// ```swift
    /// inventory.fetch(\.weapon) // Fetches all weapons.
    /// ```
    func fetchByItem(_ transform: (Item) -> Item?) -> [Measurement<Item, Tally>] {
        fetch {
            guard let item = transform($0.unit) else { return nil }

            return item.x($0.value)
        }
    }
    /// Checks whether a catalogue has enough supply for a given criteria.
    /// - Parameters:
    ///   - tally: How much is required to pass the check.
    ///   - transform: How should stock be counted?
    ///
    /// - Returns: `true` when the catalogue can supply, `false` otherwise.
    /// 
    /// Can be used together with enum case paths for a more declarative solution:
    /// ```swift
    /// inventory.has(15, \.star)
    /// ```
    func has(
        _ tally: Tally,
        _ transform: (Item) -> Item?
    ) -> Bool {
        fetchByItem(transform).has(tally)
    }
    /// Checks whether a catalogue has enough supply for a given criteria.
    /// - Parameter contents: Contents to be checked.
    /// - Returns: `true` when the catalogue can supply, `false` otherwise.
    func has(
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> Bool {
        contents().allSatisfy { has($0) }
    }
    /// Intersection between a catalogue and a list of contents.
    /// - Parameters:
    ///   - other: List of contents to compare against.
    ///   - overlap: Overlap between two measures.
    ///   - compose: Defines the measure for a given list of matches.
    ///
    /// - Returns: List of intersecting items.
    /// 
    /// Examples:
    /// ```swift
    /// inventory.intersection {
    ///   50 * .soldierSword(.rare)
    ///   Star(.rr, 3)
    /// } overlap: {
    ///   guard $0.unit == $1.unit else { return nil }
    ///
    ///   return $0.unit.x(min($0.value, $1.value))
    /// }
    /// ```
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
    /// Items in the catalogue that do not appear in the list of contents.
    /// - Parameters:
    ///   - other: List of contents to check against.
    ///   - check: Check for whether two measurements overlap.
    ///
    /// - Returns: List of contents in the catalogue that do not overlap.
    /// 
    /// Example:
    /// ```swift
    /// inventory.uniqueAgainst {
    ///   50 * coins
    /// }
    /// ```
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
    /// Items in the catalogue that do not appear in the list of contents.
    /// - Parameters:
    ///   - other: List of contents to check against.
    ///   - equals: Check for whether two items overlap.
    ///
    /// - Returns: List of contents in the catalogue of non-overlapping items.
    /// 
    /// Example:
    /// ```swift
    /// inventory.uniqueNotIn {
    ///   discardPile
    ///   drawPile
    /// } equals: {
    ///   $0.unit == $1.unit
    /// }
    /// ```
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
    /// Releases all of the contents in the dispenser.
    /// - Returns: List of released items
    mutating func releaseAll() -> [Measurement<Item, Tally>] {
        releaseAll { _ in true }
    }
    /// Releases contents of the dispenser based on a predicate.
    /// - Parameter predicate: Predicate of measurements to release.
    /// - Returns: List of released items.
    mutating func releaseAll(
        where predicate: (Measurement<Item, Tally>) -> Bool
    ) -> [Measurement<Item, Tally>] {
        let forRemoval = fetch(where: predicate)
        return release { forRemoval }
    }
}

// MARK: Self.Item: Comparable
public extension Catalogue where Item: Comparable {
    /// A description
    /// - Parameters:
    ///   - other: List of contents to compare against.
    ///   - compose: Defines the measure for a given list of matches.
    ///
    /// - Returns: List of intersecting items.
    func intersection(
        @ItemBuilder<Item> with other: () -> [Measurement<Item, Tally>],
        compose: ([Measurement<Item, Tally>]) -> Measurement<Item, Tally>? = \.first
    ) -> [Measurement<Item, Tally>] {
        intersection(with: other, overlap: {
            guard $0.unit == $1.unit else { return nil }

            let minimum = min($0.value, $1.value)
            return switch minimum {
                case .fixed(0), .nullify:
                    nil
                default:
                    $0.unit.x(minimum)
            }
        }, compose: compose)
    }
}

// MARK: Self.Item: Equatable
public extension Catalogue where Item: Equatable {
    /// Checks whether a catalogue has enough supply for a given criteria.
    /// - Parameter contents: Contents to be checked.
    /// - Returns: `true` when the catalogue can supply, `false` otherwise.
    func has(_ content: Measurement<Item, Tally>) -> Bool {
        has(content.value) { $0 == content.unit ? $0 : nil }
    }
    /// Checks whether a catalogue does not have the supply for a given criteria.
    /// - Parameter contents: Contents to be checked.
    /// - Returns: `true` when the catalogue cannot supply everything, `false` if it can.
    func lacking(
        @ItemBuilder<Item> _ contents: () -> [Measurement<Item, Tally>]
    ) -> Bool {
        !contents().allSatisfy { has($0) }
    }
    /// Items in the catalogue that do not appear in the list of contents.
    /// - Parameters:
    ///   - other: List of contents to check against.
    ///
    /// - Returns: List of contents in the catalogue of non-overlapping items.
    func uniqueNotIn(
        @ItemBuilder<Item> _ other: () -> [Measurement<Item, Tally>]
    ) -> [Measurement<Item, Tally>] {
        uniqueNotIn(other, equals: ==)
    }
}
