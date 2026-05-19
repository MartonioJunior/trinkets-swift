//
//  Dispenser+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

@testable import Inventory
import Testing
import TrinketsUnits

struct DispenserTests {
    // MARK: Mocks
    struct Mock: Dispenser, Sendable {
        typealias Item = MockItem

        var released: [Measurement<MockItem, Tally>]
        var callback: @Sendable (Measurement<MockItem, Tally>) -> Measurement<MockItem, Tally>?

        mutating func release(_ content: Measurement<MockItem, Tally>) -> Measurement<MockItem, Tally>? {
            let remainder = callback(content)

            if remainder == nil {
                released.append(content)
            }

            return callback(content)
        }

        static func shouldRelease(_ value: Bool) -> Self {
            .init(released: []) { value ? nil : $0 }
        }
    }

    // MARK: Default Implementation
    @Test("Releases the items from the dispenser", arguments: [
        (
            Mock.shouldRelease(true),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.shouldRelease(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)]
        )
    ])
    func release(
        _ sut: Mock,
        _ contents: [Measurement<MockItem, Tally>],
        expected: [Measurement<MockItem, Tally>]
    ) {
        var sut = sut
        let result = sut.release { contents }
        #expect(result == expected)
    }

    @Test("Moves items from dispenser to depot", arguments: [
        (
            Mock.shouldRelease(true),
            DepotTests.Mock.shouldAbsorb(true),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [Measurement<MockItem, Tally>](),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)]
        ),
        (
            Mock.shouldRelease(false),
            DepotTests.Mock.shouldAbsorb(true),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.shouldRelease(true),
            DepotTests.Mock.shouldAbsorb(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.shouldRelease(false),
            DepotTests.Mock.shouldAbsorb(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [Measurement<MockItem, Tally>]()
        )
    ])
    func transfer(
        _ sut: Mock,
        to depot: DepotTests.Mock,
        _ contents: [Measurement<MockItem, Tally>],
        expected: [Measurement<MockItem, Tally>],
        depotExpected: [Measurement<MockItem, Tally>]
    ) {
        var sut = sut
        var depot = depot
        let result = sut.transfer(to: &depot) { contents }
        #expect(result == expected)
        #expect(depot.stored == depotExpected)
    }

    @Test("Performs the release as a mutation", arguments: [
        (
            Mock.shouldRelease(true),
            MockItem.number(3).x(2),
            [MockItem.number(3).x(2)]
        ),
        (
            Mock.shouldRelease(false),
            MockItem.number(3).x(2),
            [Measurement<MockItem, Tally>]()
        )
    ])
    func minusAssign(
        lhs: Mock,
        rhs: Measurement<MockItem, Tally>,
        expected: [Measurement<MockItem, Tally>]
    ) {
        var lhs = lhs
        lhs -= rhs
        #expect(lhs.released == expected)
    }
}
