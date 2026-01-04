//
//  Catalogue+Tests+Dispenser.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/01/2026.
//

@testable import Inventory
import Testing

extension CatalogueTests {
    // MARK: Self: Dispenser
    struct ConformsToDispenser {
        @Test("Removes all fetchable elements in the catalogue", arguments: [
            (
                Mock.numbers(4, 2, 9),
                [CatalogueTests.measure(4), CatalogueTests.measure(2), CatalogueTests.measure(9)]
            )
        ])
        func releaseAll(
            _ sut: Mock,
            expected: [MockItem.Measure]
        ) {
            var sut = sut
            let result = sut.releaseAll()
            #expect(result == expected)
        }

        @Test("Removes all fetchable elements that fulfill predicate", arguments: [
            (
                Mock.numbers(4, 2, 9),
                CatalogueTests.greaterThan(6),
                [CatalogueTests.measure(9)]
            ),
            (
                Mock.numbers(4, 2, 9),
                CatalogueTests.always(true),
                [CatalogueTests.measure(4), CatalogueTests.measure(2), CatalogueTests.measure(9)]
            ),
            (
                Mock.numbers(4, 2, 9),
                CatalogueTests.always(false),
                [MockItem.Measure]()
            )
        ])
        func releaseAll(
            _ sut: Mock,
            where predicate: @Sendable (MockItem.Measure) -> Bool,
            expected: [MockItem.Measure]
        ) {
            var sut = sut
            let result = sut.releaseAll(where: predicate)
            #expect(result == expected)
        }
    }
}
