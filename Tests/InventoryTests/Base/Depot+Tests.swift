//
//  Depot+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

@testable import Inventory
import Testing

struct DepotTests {
    // MARK: Mocks
    struct Mock: Depot, Sendable {
        typealias Item = MockItem
        var stored: [Item.Measure]
        var callback: @Sendable (Item.Measure) -> Item.Measure?

        mutating func store(_ content: Item.Measure) -> Item.Measure? {
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
            [MockItem.Measure]()
        ),
        (
            Mock.shouldAbsorb(false),
            [MockItem.number(3).x(2), MockItem.number(4).x(3)],
            [MockItem.number(3).x(2), MockItem.number(4).x(3)]
        )
    ])
    func store(
        _ sut: Mock,
        _ contents: [MockItem.Measure],
        expected: [MockItem.Measure]
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
            [MockItem.Measure]()
        )
    ])
    func plusAssign(
        lhs: Mock,
        rhs: MockItem.Measure,
        expected: [MockItem.Measure]
    ) {
        var lhs = lhs
        lhs += rhs
        #expect(lhs.stored == expected)
    }
}
