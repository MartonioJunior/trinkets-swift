//
//  ItemCollection+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

@testable import Inventory
import Testing
import TrinketsUnits

struct ItemCollectionTests {
    typealias Mock = MockInventory
    struct EmptyInitItemCollection: ItemCollection, Equatable {
        typealias Item = MockItem

        var contents: [Measurement<MockItem, Tally>]

        init(_ contents: some Sequence<Measurement<MockItem, Tally>>) { self.contents = contents.map(\.self) }
    }

    // MARK: Default Implementation
    @Test("Creates an item collection with empty contents")
    func initializer() {
        #expect(EmptyInitItemCollection() == EmptyInitItemCollection([]))
    }

    @Test("Creates an item collection with the given contents", arguments: [
        (
            [MockItem.number(4).x(3), MockItem.text("c").x(7)],
            Mock([MockItem.number(4).x(3), MockItem.text("c").x(7)])
        )
    ])
    func initializer(_ contents: [Measurement<MockItem, Tally>], expected: Mock) {
        let result = Mock { contents }
        #expect(result == expected)
    }

    // MARK: Self: ExpressibleByArrayLiteral
    struct ConformsToExpressibleByArrayLiteral {
        @Test("Creates a new item collection with the given contents", arguments: [
            (
                MockItem.number(4).x(3),
                MockItem.text("c").x(7),
                Mock([MockItem.number(4).x(3), MockItem.text("c").x(7)])
            )
        ])
        func initializer(_ a: Measurement<MockItem, Tally>, _ b: Measurement<MockItem, Tally>, expected: Mock) {
            let result = Mock(arrayLiteral: a, b)
            #expect(result == expected)
        }
    }
}
