//
//  Tally+Units.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/12/2025.
//

import TrinketsUnits

// MARK: Measurement (EX)
public extension Measurement where Value == Tally {
    /// Checks whether a measurement has enough tally.
    /// - Parameter tally: Tally to evaluate against.
    /// - Returns: `true` when there's enough stock, `false` when there isn't.
    func contains(_ tally: Tally) -> Bool {
        switch tally {
            case .fixed(0): true
            default: tally <= value
        }
    }
    /// Checks whether a measure can supply another item.
    /// - Parameters:
    ///   - measure: Measurement to be supplied.
    ///   - equals: Checks whether the item can supply another of the same type.
    ///
    /// - Returns: `true` when it can be supplied, `false` otherwise.
    func canSupply(
        _ measure: Self,
        equals: (UnitType, UnitType) -> Bool
    ) -> Bool {
        guard equals(unit, measure.unit) else { return false }

        return contains(measure.value)
    }
    /// Combines the stocks of two items together into one.
    /// - Parameters:
    ///   - other: Stock for another item.
    ///   - operation: How should tallies be combined.
    ///   - predicate: Checks whether the stock can be merged with another.
    ///
    /// - Returns: Combined stock of items when successful, `nil` otherwise.
    func mergeTallies(
        with other: Self,
        _ operation: (Tally, Tally) -> Tally = { $0 + $1 },
        onlyWhen predicate: (Self, Self) -> Bool = { _, _ in true }
    ) -> Self? {
        guard predicate(self, other) else { return nil }

        return mapValue { operation($0, other.value) }
    }
}

public extension Measurement where UnitType: Equatable, Value == Tally {
    /// Checks whether a measure can supply another item.
    /// - Parameter measure: Measurement to be supplied.
    /// - Returns: `true` when it can be supplied, `false` otherwise.
    func canSupply(_ measure: Self) -> Bool {
        canSupply(measure, equals: ==)
    }
}

// MARK: RangeReplaceableCollection (EX)
public extension RangeReplaceableCollection where Self: MutableCollection {
    /// Adds the stock into the collection.
    /// - Parameters:
    ///   - supply: Stock to be added in.
    ///   - stacking: Indicates whether to stack into an existing entry or create a new one.
    ///
    mutating func allocate<Item: Measurable & Equatable, Value: AdditiveArithmetic>(
        _ supply: Element,
        stacking: Bool
    ) where Element == Measurement<Item, Value> {
        guard stacking, let index = firstIndex(where: { $0.unit == supply.unit }) else {
            append(supply)
            return
        }

        self[index].value += supply.value
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Checks whether a sequence has enough stock.
    /// 
    /// Use this method after filtering out to only the essential values.
    /// - Parameter tally: Quantity to be evaluated against.
    /// - Returns: `true` when there's enough stock, `false` otherwise.
    func has<Item: Measurable>(
        _ tally: Tally
    ) -> Bool where Element == Measurement<Item, Tally> {
        switch tally {
            case let .fixed(value):
                self.tally().reduce(.zero, +) >= .fixed(value)
            case .infinite:
                contains { $0.value == .infinite }
            case .nullify:
                contains { $0.value == .nullify }
        }
    }
    /// Tally values from this sequence.
    /// - Returns: List of tally values.
    func tally<Item: Measurable>() -> [Tally] where Element == Measurement<Item, Tally> {
        map(\.value)
    }
    /// Transforms tallied values into a new array.
    /// - Parameter transform: Transformation function.
    /// - Returns: An array of `T` instances.
    func tally<Item: Measurable, T: AdditiveArithmetic>(
        _ transform: (Tally) -> T,
    ) -> [T] where Element == Measurement<Item, Tally> {
        map { transform($0.value) }
    }
}
