//
//  Dimension+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

import Testing
@testable import TrinketsUnits

struct DimensionTests {
    public typealias Mock = Gil

    @Test("Creates measurement from Domain", arguments: [
        (24, Mock.Unit.zeni, Measurement(value: 24, unit: .zeni))
    ])
    func of(_ value: Mock.Value, _ unit: Mock.Unit, expected: Mock.Measure) {
        let result = Mock.of(value, unit)
        #expect(result == expected)
    }

    @Test("Allows calling units from the Domain", arguments: [
        (Mock.Unit.zeni, Mock.Unit.zeni)
    ])
    func `in`(_ unit: Mock.Unit, expected: Mock.Unit) {
        let result = Mock.in(unit)
        #expect(result == expected)
    }

    // MARK: Unit (EX)
    @Test("Returns base unit")
    func `default`() {
        #expect(Mock.Unit.default == Mock.baseUnit)
    }
}
