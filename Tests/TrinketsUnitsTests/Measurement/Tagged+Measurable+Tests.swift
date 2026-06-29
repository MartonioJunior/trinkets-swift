//
//  Tagged+Measurable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/06/2026.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct TaggedTests {
    @Test("Divides measurements as they're guaranteed to be the same", arguments: [
        (Tagged<RPGMoney.Gil, Double>(24), Tagged<RPGMoney.Gil, Double>(3), 8.0),
        (Tagged<RPGMoney.Gil, Double>(11), Tagged<RPGMoney.Gil, Double>(4), 2.75)
    ])
    func divideStatic(
        lhs: Tagged<RPGMoney.Gil, Double>,
        rhs: Tagged<RPGMoney.Gil, Double>,
        expected: Double
    ) {
        let result = lhs / rhs
        #expect(result == expected)
    }
}
