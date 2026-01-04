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

        var numbers: [MockItem.Measure]

        init(_ items: Tally...) {
            self.numbers = items.compactMap(measure)
        }

        func fetch<T>(_ transform: (MockItem.Measure) -> T?) -> [T] {
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
                [MockItem.Measure]()
            ),
            (
                Mock.numbers(3, 4, 5), [MockItem.Measure](),
                CatalogueTests.compose(true),
                [MockItem.Measure]()
            ),
            (
                Mock.numbers(), [MockItem.Measure](),
                CatalogueTests.compose(true),
                [MockItem.Measure]()
            )
        ])
        func intersection(
             _ sut: Mock,
            with other: [MockItem.Measure],
            compose: @Sendable ([MockItem.Measure]) -> MockItem.Measure?,
            expected: [MockItem.Measure]
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
                [MockItem.Measure]()
            ),
            (
                Mock.numbers(3, 4, 5), [MockItem.Measure](),
                [MockItem.Measure]()
            ),
            (
                Mock.numbers(), [MockItem.Measure](),
                [MockItem.Measure]()
            )
        ])
        func intersection(
             _ sut: Mock,
            with other: [MockItem.Measure],
            expected: [MockItem.Measure]
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
        func has(_ sut: DefaultHas, _ contents: MockItem.Measure, expected: Bool) {
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
                Mock.numbers(3, 4, 5), [MockItem.Measure](),
                false
            ),
            (
                Mock.numbers(), [MockItem.Measure](),
                false
            )
        ])
        func lacking(
            _ sut: Mock,
            _ contents: [MockItem.Measure],
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
                [MockItem.Measure]()
            ),
            (
                Mock.numbers(3, 4, 5), [MockItem.Measure](),
                [CatalogueTests.measure(3), CatalogueTests.measure(4), CatalogueTests.measure(5)]
            ),
            (
                Mock.numbers(), [MockItem.Measure](),
                [MockItem.Measure]()
            )
        ])
        func uniqueNotIn(
            _ sut: Mock,
            _ other: [MockItem.Measure],
            expected: [MockItem.Measure]
        ) {
            let result = sut.uniqueNotIn { other }
            #expect(result == expected)
        }
    }
}
