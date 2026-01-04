//
//  Tally+Units+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/01/2026.
//

@testable import Inventory
import Testing

// MARK: Measurement (EX)
fileprivate struct MeasurementTests {
    typealias Mock = MockItem.Measure

    @Test("Checks if supply has enough of a tally", arguments: [
        (MockItem(id: "apple").x(Tally.value(8)), 6, true),
        (MockItem(id: "apple").x(Tally.value(8)), 12, false),
        (MockItem(id: "apple").x(Tally.infinite), UInt.max, true),
        (MockItem(id: "apple").x(Tally.nullify), UInt.zero, true),
        (MockItem(id: "apple").x(Tally.nullify), 3, false)
    ])
    func contains(_ sut: MockItem.Measure, _ amount: UInt, expected: Bool) {
        let result = sut.contains(.value(amount))
        #expect(result == expected)
    }

    @Test("Checks if supply has enough of a tally with predicate", arguments: [
        (MockItem(id: "apple").x(Tally.value(8)), 6, true, true),
        (MockItem(id: "apple").x(Tally.value(8)), 6, false, false),
        (MockItem(id: "apple").x(Tally.value(8)), 12, true, false),
        (MockItem(id: "apple").x(Tally.value(8)), 12, false, false),
        (MockItem(id: "apple").x(Tally.infinite), UInt.max, true, true),
        (MockItem(id: "apple").x(Tally.infinite), UInt.max, false, false),
        (MockItem(id: "apple").x(Tally.nullify), UInt.zero, true, true),
        (MockItem(id: "apple").x(Tally.nullify), UInt.zero, false, false),
        (MockItem(id: "apple").x(Tally.nullify), 3, true, false),
        (MockItem(id: "apple").x(Tally.nullify), 3, false, false)
    ])
    func canSupply(_ sut: Mock, _ amount: UInt, equals: Bool, expected: Bool) {
        let result = sut.canSupply(sut.unit.x(.value(amount))) { _, _ in equals }
        #expect(result == expected)
    }

    @Test("Maps tally based on the stock information", arguments: [
        (
            MockItem(id: "apple").x(Tally.value(8)),
            MockItem(id: "apple").x(Tally.value(16)),
            MockItem(id: "apple").x(Tally.value(24)),
        )
    ])
    func mergeTallies(_ sut: Mock, with other: Mock, expected: Mock?) {
        let result = sut.mergeTallies(with: other)
        #expect(result == expected)
    }

    @Test("Maps tally based on the stock information", arguments: [
        (
            MockItem(id: "apple").x(Tally.value(8)),
            MockItem(id: "apple").x(Tally.value(16)),
            true,
            MockItem(id: "apple").x(Tally.value(24)),
        ),
        (
            MockItem(id: "apple").x(Tally.value(8)),
            MockItem(id: "apple").x(Tally.value(16)),
            false,
            Mock?.none,
        )
    ])
    func mergeTallies(_ sut: Mock, with other: Mock, onlyWhen predicate: Bool, expected: Mock?) {
        let result = sut.mergeTallies(with: other, +) { _, _ in predicate }
        #expect(result == expected)
    }
}

// MARK: RangeReplaceableCollection (EX)
fileprivate struct RangeReplaceableCollectionTests {
    @Test("Adds stock as new entry or on top of another", arguments: [
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(6).x(8),
            false,
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(6).x(8)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(6).x(.infinite),
            false,
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(6).x(.infinite)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(6).x(.nullify),
            false,
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(6).x(.nullify)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(4).x(8),
            false,
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(4).x(8)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(4).x(.infinite),
            false,
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(4).x(.infinite)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(4).x(.nullify),
            false,
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(4).x(.nullify)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(6).x(8),
            true,
            [MockItem.number(4).x(3), MockItem.number(6).x(10)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(6).x(.infinite),
            true,
            [MockItem.number(4).x(3), MockItem.number(6).x(.infinite)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(6).x(.nullify),
            true,
            [MockItem.number(4).x(3), MockItem.number(6).x(.nullify)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(4).x(8),
            true,
            [MockItem.number(4).x(11), MockItem.number(6).x(2)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(4).x(.infinite),
            true,
            [MockItem.number(4).x(.infinite), MockItem.number(6).x(2)]
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2)],
            MockItem.number(4).x(.nullify),
            true,
            [MockItem.number(4).x(.nullify), MockItem.number(6).x(2)]
        )
    ])
    func allocate(
        _ sut: [MockItem.Measure],
        _ supply: MockItem.Measure,
        stacking: Bool,
        expected: [MockItem.Measure]
    ) {
        var sut = sut
        sut.allocate(supply, stacking: stacking)
        #expect(sut == expected)
    }
}

// MARK: Sequence (EX)
fileprivate struct SequenceTests {
    @Test("Checks if there's enough stock in a sequence", arguments: [
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(4)],
            Tally.value(12), true
        ),
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(4)],
            Tally.value(2), true
        ),
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(4)],
            Tally.value(32), false
        ),
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(4)],
            Tally.infinite, false
        ),
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(.nullify)],
            Tally.infinite, false
        ),
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(.infinite)],
            Tally.infinite, true
        ),
        (
            [MockItem.number(2).x(9), MockItem.number(6).x(4)],
            Tally.nullify, false
        ),
        (
            [MockItem.number(2).x(.nullify), MockItem.number(6).x(4)],
            Tally.nullify, true
        ),
        (
            [MockItem.number(2).x(.infinite), MockItem.number(6).x(4)],
            Tally.nullify, false
        )
    ])
    func has(
        _ sut: [MockItem.Measure],
        _ tally: Tally,
        expected: Bool
    ) {
        let result = sut.has(tally)
        #expect(result == expected)
    }

    @Test("Reduces all stock entries in a collection based on a certain type", arguments: [
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(4).x(8)],
            [Tally.value(3), Tally.value(2), Tally.value(8)]
        ),
        (
            [MockItem.Measure](),
            [Tally]()
        )
    ])
    func tally(
        _ sut: [MockItem.Measure],
        expected: [MockItem.Value]
    ) {
        let result = sut.tally()
        #expect(result == expected)
    }

    @Test("Reduces all stock entries in a collection based on a certain type", arguments: [
        (
            [MockItem.number(4).x(3), MockItem.number(6).x(2), MockItem.number(4).x(8)],
            [3, 2, 8]
        ),
        (
            [MockItem.Measure](),
            [Tally.Value]()
        )
    ])
    func tallyTransform(
        _ sut: [MockItem.Measure],
        expected: [Tally.Value]
    ) {
        let result = sut.tally { $0.amount }
        #expect(result == expected)
    }
}
