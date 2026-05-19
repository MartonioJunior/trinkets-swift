//
//  Catalogue+Tests+Item.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/01/2026.
//

@testable import Inventory
import Testing

extension CatalogueTests {
    // MARK: Mocks
    struct DefaultHas: Catalogue {
        typealias Item = MockItem

        var numbers: [Measurement<MockItem, Tally>]

        init(_ items: Tally...) {
            self.numbers = items.compactMap(measure)
        }

        func fetch<T>(_ transform: (Measurement<MockItem, Tally>) -> T?) -> [T] {
            numbers.compactMap(transform)
        }
    }

    // MARK: Self.Item: Comparable
    struct ItemConformsToComparable {
        @Test("Returns overlap between catalogues", arguments: [
            (
                Mock.numbers(3, 4, 5), [CatalogueTests.measure(5), CatalogueTests.measure(6)],
                CatalogueTests.compose(true),
                [CatalogueTests.measure(5)]
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                CatalogueTests.compose(false),
                [CatalogueTests.measure(5), MockItem.number(6).x(4)]
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(.nullify), MockItem.number(6).x(4)],
                CatalogueTests.compose(false),
                [MockItem.number(6).x(4)]
            ),
            (
                Mock.numbers(0), [MockItem.number(0).x(9), MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                CatalogueTests.compose(true),
                [Measurement<MockItem, Tally>]()
            ),
            (
                Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
                CatalogueTests.compose(true),
                [Measurement<MockItem, Tally>]()
            ),
            (
                Mock.numbers(), [Measurement<MockItem, Tally>](),
                CatalogueTests.compose(true),
                [Measurement<MockItem, Tally>]()
            )
        ])
        func intersection(
             _ sut: Mock,
            with other: [Measurement<MockItem, Tally>],
            compose: @Sendable ([Measurement<MockItem, Tally>]) -> Measurement<MockItem, Tally>?,
            expected: [Measurement<MockItem, Tally>]
        ) {
            let result = sut.intersection(with: { other }, compose: compose)
            #expect(result == expected)
        }

        @Test("Returns overlap between catalogues", arguments: [
            (
                Mock.numbers(3, 4, 5), [CatalogueTests.measure(5), CatalogueTests.measure(6)],
                [CatalogueTests.measure(5)]
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                [CatalogueTests.measure(5), MockItem.number(6).x(4)]
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(.nullify), MockItem.number(6).x(4)],
                [MockItem.number(6).x(4)]
            ),
            (
                Mock.numbers(0), [MockItem.number(0).x(9), MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                [Measurement<MockItem, Tally>]()
            ),
            (
                Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
                [Measurement<MockItem, Tally>]()
            ),
            (
                Mock.numbers(), [Measurement<MockItem, Tally>](),
                [Measurement<MockItem, Tally>]()
            )
        ])
        func intersection(
             _ sut: Mock,
            with other: [Measurement<MockItem, Tally>],
            expected: [Measurement<MockItem, Tally>]
        ) {
            let result = sut.intersection { other }
            #expect(result == expected)
        }
    }

    // MARK: Self.Item: Equatable
    struct ItemConformsToEquatable {
        @Test("Check if the inventory has the given contents", arguments: [
            (DefaultHas(3, 4, 5), CatalogueTests.measure(3), true),
            (DefaultHas(3, 4, 5), CatalogueTests.measure(6), false),
            (DefaultHas(3, 4, 5), MockItem.number(3).x(2), true),
            (DefaultHas(), MockItem.number(3).x(.nullify), false)
        ])
        func has(_ sut: DefaultHas, _ contents: Measurement<MockItem, Tally>, expected: Bool) {
            let result = sut.has(contents)
            #expect(result == expected)
        }

        @Test("Checks if the contents are not in the catalogue", arguments: [
            (
                Mock.numbers(3, 4, 5), [CatalogueTests.measure(5), CatalogueTests.measure(6)],
                true
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                true
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(2), MockItem.number(6).x(4)],
                false
            ),
            (
                Mock.numbers(0), [MockItem.number(0).x(9), MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                true
            ),
            (
                Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
                false
            ),
            (
                Mock.numbers(), [Measurement<MockItem, Tally>](),
                false
            )
        ])
        func lacking(
            _ sut: Mock,
            _ contents: [Measurement<MockItem, Tally>],
            expected: Bool
        ) {
            let result = sut.lacking { contents }
            #expect(result == expected)
        }

        @Test("Returns elements in catalogue A not in B", arguments: [
            (
                Mock.numbers(3, 4, 5), [CatalogueTests.measure(5), CatalogueTests.measure(6)],
                [CatalogueTests.measure(3), CatalogueTests.measure(4)]
            ),
            (
                Mock.numbers(3, 5, 4, 5, 6),
                [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                [CatalogueTests.measure(3), CatalogueTests.measure(4)]
            ),
            (
                Mock.numbers(), [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
                [Measurement<MockItem, Tally>]()
            ),
            (
                Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
                [CatalogueTests.measure(3), CatalogueTests.measure(4), CatalogueTests.measure(5)]
            ),
            (
                Mock.numbers(), [Measurement<MockItem, Tally>](),
                [Measurement<MockItem, Tally>]()
            )
        ])
        func uniqueNotIn(
            _ sut: Mock,
            _ other: [Measurement<MockItem, Tally>],
            expected: [Measurement<MockItem, Tally>]
        ) {
            let result = sut.uniqueNotIn { other }
            #expect(result == expected)
        }
    }
}
