//
//  Inventory+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/12/2025.
//

@testable import Inventory
import Testing

struct InventoryTests {
    // MARK: Mock
    typealias Mock = MockInventory

    // MARK: Default Implementation
    @Test("Creates a list of contents with new values", arguments: [
        (Mock([MockItem.number(8).x(12)]), [MockItem.number(8).x(24)]),
        (Mock(), [MockItem.Measure]())
    ])
    func mapValues(
        _ sut: Mock,
        expected: [MockItem.Measure]
    ) {
        let result = sut.mapValues { $0 * 2 }
        #expect(result == expected)
    }

    @Test("Combines the contents of the inventory with a list of items", arguments: [
        (
            Mock([MockItem.number(4).x(6)]), [MockItem.number(6).x(3)],
            [MockItem.number(4).x(6), MockItem.number(6).x(3)]
        ),
        (
            Mock(), [MockItem.number(6).x(3)],
            [MockItem.number(6).x(3)]
        ),
        (
            Mock([MockItem.number(4).x(6)]), [MockItem.Measure](),
            [MockItem.number(4).x(6)]
        ),
        (
            Mock(), [MockItem.Measure](),
            [MockItem.Measure]()
        )
    ])
    func union(
        _ sut: Mock,
        with other: [MockItem.Measure],
        expected: [MockItem.Measure]
    ) {
        let result = sut.union { other }
        #expect(result == expected)
    }

    @Test("Maps values using a multiplier", arguments: [
        (Mock([MockItem.number(8).x(12)]), UInt(2), [MockItem.number(8).x(24)]),
        (Mock([MockItem.number(8).x(12)]), UInt(0), [MockItem.number(8).x(0)]),
        (Mock(), UInt(6), [MockItem.Measure]())
    ])
    func times(
        lhs: Mock,
        rhs: UInt,
        expected: [MockItem.Measure]
    ) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    @Test("Maps values using a division", arguments: [
        (Mock([MockItem.number(8).x(12)]), UInt(2), [MockItem.number(8).x(6)]),
        (Mock([MockItem.number(8).x(12)]), UInt(0), [MockItem.number(8).x(0)]),
        (Mock(), UInt(6), [MockItem.Measure]())
    ])
    func division(
        lhs: Mock,
        rhs: UInt,
        expected: [MockItem.Measure]
    ) {
        let result = lhs / rhs
        #expect(result == expected)
    }

    // MARK: Self: Catalogue
    struct ConformsToCatalogue {
        @Test("Uses contents as a default implementation", arguments: [
            (Mock([MockItem.number(8).x(12)]), [MockItem.number(8).x(12)]),
            (Mock(), [MockItem.Measure]())
        ])
        func fetch(
            _ sut: Mock,
            expected: [MockItem.Measure]
        ) {
            let result = sut.fetch(\.self)
            #expect(result == expected)
        }
    }

    // MARK: Self: Dispenser
    struct ConformsToDispenser {

        @Test("Moves contents from one inventory to another", arguments: [
            (
                Mock([MockItem.number(4).x(6), MockItem.number(3).x(2)]),
                DepotTests.Mock.shouldAbsorb(true),
                [MockItem.Measure](),
                [MockItem.Measure](),
                [MockItem.number(4).x(6), MockItem.number(3).x(2)]
            ),
            (
                Mock(),
                DepotTests.Mock.shouldAbsorb(true),
                [MockItem.Measure](),
                [MockItem.Measure](),
                [MockItem.Measure]()
            ),
            (
                Mock([MockItem.number(4).x(6), MockItem.number(3).x(2)]),
                DepotTests.Mock.shouldAbsorb(false),
                [MockItem.number(4).x(6), MockItem.number(3).x(2)],
                [MockItem.Measure](),
                [MockItem.Measure]()
            ),
            (
                Mock(),
                DepotTests.Mock.shouldAbsorb(false),
                [MockItem.Measure](),
                [MockItem.Measure](),
                [MockItem.Measure]()
            )
        ])
        func transferAll(
            _ sut: Mock,
            to depot: DepotTests.Mock,
            expected: [MockItem.Measure],
            expectedSut: [MockItem.Measure],
            expectedInventory: [MockItem.Measure]
        ) {
            var sut = sut
            var depot = depot

            let result = sut.transferAll(to: &depot)

            #expect(result == expected)
            #expect(sut.contents == expectedSut)
            #expect(depot.stored == expectedInventory)
        }
    }
}
