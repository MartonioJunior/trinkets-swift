//
//  Amount+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/01/2026.
//

import Testing
@testable import TrinketsUnits

struct AmountTests {
    @Test("Creates new dynamic unit", arguments: [
        ("goals")
    ])
    func initializer(_ symbol: String) {
        let result = Amount(symbol)
        #expect(result.symbol == symbol)
    }

    @Test("Creates new unit for quantity", arguments: [
        ("websites", Amount("websites"))
    ])
    func of(
        _ symbol: String,
        expected: Amount
    ) {
        let resultA = Amount[dynamicMember: symbol.description]
        let resultB = Amount.of(symbol.description)

        #expect(resultA == expected)
        #expect(resultB == expected)
    }

    @Test("Creates unit with compile-time symbol")
    func auto() {
        let refString: StaticString = #file
        let result = Amount.auto(refString)
        #expect(result == Amount(refString.description))
    }
}
