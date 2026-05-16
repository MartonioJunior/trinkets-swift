//
//  DynamicConverter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/05/2026.
//

import Testing
@testable import TrinketsUnits

struct DynamicConverterTests {
    // MARK: Syntax
    func syntax() {
        let dynamicUnit = RPGMoney.Constant(value: 4)
        let dynamicMeasure = Measurement(25, dynamicUnit)
        let targetUnit = RPGMoney.Constant(value: 2)
        #expect(dynamicMeasure.converted(to: targetUnit, .base, .converter) == Measurement(27, targetUnit))
    }

    // MARK: Initializers
}
