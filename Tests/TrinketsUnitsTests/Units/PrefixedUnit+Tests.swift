//
//  PrefixedUnit+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/05/2026.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct PrefixedUnitTests {
    // MARK: Syntax
    @Test("Defines use cases for the type")
    func syntax() {
        let dynamicUnit = RPGMoney.Constant(value: 1)
        #expect(type(of: PrefixedUnit(.whoa, dynamicUnit)) == PrefixedUnit<SlangPrefix.Whoa, RPGMoney.Constant>.self)
        #expect(type(of: Measurement(25.0, dynamicUnit).prefixed(with: .whoa)) == Measurement<PrefixedUnit<SlangPrefix.Whoa, RPGMoney.Constant>, Double>.self)

        let staticMeasure = Tagged<Material.Cloth, Double>(10)
        #expect(type(of: staticMeasure.prefixed(with: .tubular)) == Tagged<PrefixedUnit<SlangPrefix.Tubular, Material.Cloth>, Double>.self)
    }

    // MARK: Initializer
    @Test("Creates new unit by composing prefix and unit", arguments: [
        (RPGMoney.Constant(value: 4))
    ])
    func initializer(_ unit: RPGMoney.Constant) {
        let resultA = PrefixedUnit(SlangPrefix.Tubular.self, unit)
        let resultB = PrefixedUnit(.whoa, unit)
        #expect(resultA.unit == unit)
        #expect(resultB.unit == unit)
    }
}
