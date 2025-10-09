//
//  Collectable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import Testing

// MARK: Mock
struct CollectableTests {
    struct Mock: Collectable, Equatable {
        var id: String

        init(_ id: String) {
            self.id = id
        }
    }
}

// MARK: Unit (EX)
import TrinketsUnits

struct UnitTests {
    @Test("Creates a new unit using a collectable", arguments: [
        (
            CollectableTests.Mock("element"), "k",
            Unit<CollectableTests.Mock>("k", details: CollectableTests.Mock("element"))
        )
    ])
    func initializer(
        collectable: CollectableTests.Mock,
        symbol: CollectableTests.Mock.Symbol,
        expected: Unit<CollectableTests.Mock>
    ) {
        let result = Unit(collectable: collectable, symbol: symbol)
        #expect(result == expected)
    }
}
