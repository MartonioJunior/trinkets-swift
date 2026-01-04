//
//  Dispenser+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

@testable import Inventory
import Testing

struct DispenserTests {
    // MARK: Mocks
    struct Mock: Dispenser, Sendable {
        typealias Item = MockItem

        var released: [Item.Measure]
        var callback: @Sendable (Item.Measure) -> Item.Measure?

        mutating func release(_ content: Item.Measure) -> Item.Measure? {
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
            [MockItem.Measure]()
        ),
        (
            Mock.shouldRelease(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)]
        )
    ])
    func release(
        _ sut: Mock,
        _ contents: [MockItem.Measure],
        expected: [MockItem.Measure]
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
            [MockItem.Measure](),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)]
        ),
        (
            Mock.shouldRelease(false),
            DepotTests.Mock.shouldAbsorb(true),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.Measure]()
        ),
        (
            Mock.shouldRelease(true),
            DepotTests.Mock.shouldAbsorb(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.Measure]()
        ),
        (
            Mock.shouldRelease(false),
            DepotTests.Mock.shouldAbsorb(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.Measure]()
        )
    ])
    func transfer(
        _ sut: Mock,
        to depot: DepotTests.Mock,
        _ contents: [MockItem.Measure],
        expected: [MockItem.Measure],
        depotExpected: [MockItem.Measure]
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
            [MockItem.Measure]()
        )
    ])
    func minusAssign(
        lhs: Mock,
        rhs: MockItem.Measure,
        expected: [MockItem.Measure]
    ) {
        var lhs = lhs
        lhs -= rhs
        #expect(lhs.released == expected)
    }
}
