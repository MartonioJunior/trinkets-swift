//
//  Depot+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

@testable import Inventory
import Testing
import TrinketsUnits

struct DepotTests {
    typealias Item = MockItem

    // MARK: Mocks
    struct Mock: Depot, Sendable {
        var stored: [Measurement<Item, Tally>]
        var callback: @Sendable (Measurement<Item, Tally>) -> Measurement<Item, Tally>?

        mutating func store(_ content: Measurement<Item, Tally>) -> Measurement<Item, Tally>? {
            let remainder = callback(content)

            if remainder == nil {
                stored.append(content)
            }

            return callback(content)
        }

        static func shouldAbsorb(_ value: Bool) -> Self {
            .init(stored: []) { value ? nil : $0 }
        }
    }

    // MARK: Default Implementation
    @Test("Stores a list of contents in the depot", arguments: [
        (
            Mock.shouldAbsorb(true),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [Measurement<Item, Tally>]()
        ),
        (
            Mock.shouldAbsorb(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)]
        )
    ])
    func store(
        _ sut: Mock,
        _ contents: [Measurement<Item, Tally>],
        expected: [Measurement<Item, Tally>]
    ) {
        var sut = sut
        let result = sut.store { contents }
        #expect(result == expected)
    }

    @Test("Performs the store as a mutation", arguments: [
        (
            Mock.shouldAbsorb(true),
            MockItem.number(3).x(2),
            [MockItem.number(3).x(2)]
        ),
        (
            Mock.shouldAbsorb(false),
            MockItem.number(3).x(2),
            [Measurement<Item, Tally>]()
        )
    ])
    func plusAssign(
        lhs: Mock,
        rhs: Measurement<Item, Tally>,
        expected: [Measurement<Item, Tally>]
    ) {
        var lhs = lhs
        lhs += rhs
        #expect(lhs.stored == expected)
    }
}
