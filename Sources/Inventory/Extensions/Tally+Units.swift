//
//  Tally+Units.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/12/2025.
//

import TrinketsUnits

// MARK: Measurement (EX)
public extension Measurement where UnitType.Value == Tally {
    func contains(_ tally: Tally) -> Bool {
        switch tally {
            case .value(0): true
            default: tally <= value
        }
    }

    func canSupply(
        _ measure: Self,
        equals: (UnitType, UnitType) -> Bool
    ) -> Bool {
        guard equals(unit, measure.unit) else { return false }

        return contains(measure.value)
    }

    func mergeTallies(
        with other: Self,
        _ operation: (Tally, Tally) -> Tally = { $0 + $1 },
        onlyWhen predicate: (Self, Self) -> Bool = { _, _ in true }
    ) -> Self? {
        guard predicate(self, other) else { return nil }

        return map { operation($0, other.value) }
    }
}

public extension Measurement where UnitType: Equatable, UnitType.Value == Tally {
    func canSupply(_ measure: Self) -> Bool {
        canSupply(measure, equals: ==)
    }
}

// MARK: RangeReplaceableCollection (EX)
public extension RangeReplaceableCollection where Self: MutableCollection {
    mutating func allocate<Item: Measurable & Equatable>(
        _ supply: Element,
        stacking: Bool
    ) where Element == Item.Measure, Item.Value: AdditiveArithmetic {
        guard stacking, let index = firstIndex(where: { $0.unit == supply.unit }) else {
            append(supply)
            return
        }

        self[index].value += supply.value
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    func has<Item: Measurable>(
        _ tally: Tally
    ) -> Bool where Element == Item.Measure, Item.Value == Tally {
        switch tally {
            case let .value(value):
                self.tally().reduce(.zero, +) >= .value(value)
            case .infinite:
                contains { $0.value == .infinite }
            case .nullify:
                contains { $0.value == .nullify }
        }
    }

    func tally<Item: Measurable>() -> [Item.Value] where Element == Item.Measure {
        map(\.value)
    }

    func tally<Item: Measurable, T: AdditiveArithmetic>(
        _ transform: (Element.Value) -> T,
    ) -> [T] where Element == Item.Measure {
        map { transform($0.value) }
    }
}
