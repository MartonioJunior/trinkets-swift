//
//  Dimension+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

import Testing
@testable import TrinketsUnits

struct DimensionTests {
    public typealias Mock = RPGMoney

    @Test("Creates measurement from Domain", arguments: [
        (24, RPGMoney.Constant(value: 77), Measurement(24, RPGMoney.Constant(value: 77)))
    ])
    func of(_ value: Int, _ unit: RPGMoney.Constant, expected: Measurement<RPGMoney.Constant, Int>) {
        let result = Mock.of(value, unit)
        #expect(result == expected)
    }

    @Test("Allows calling units from the Domain", arguments: [
        (RPGMoney.Constant(value: 77), RPGMoney.Constant(value: 77))
    ])
    func `in`(_ unit: RPGMoney.Constant, expected: RPGMoney.Constant) {
        let result = Mock.in(unit)
        #expect(result == expected)
    }
}
