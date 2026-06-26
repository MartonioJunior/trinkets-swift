//
//  Convertible+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/04/2026.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct ConvertibleTests {
    // MARK: Measurement (EX)
    struct MeasurementTests {
        @Test("Uses dynamic converter to change units", arguments: [
            (Measurement(10, RPGMoney.Constant(value: 12)), RPGMoney.Constant(value: 6), Measurement(16, RPGMoney.Constant(value: 6))),
            (Measurement(15, RPGMoney.Constant(value: 0)), RPGMoney.Constant(value: 20), Measurement(-5, RPGMoney.Constant(value: 20))),
            (Measurement(-10, RPGMoney.Constant(value: 15)), RPGMoney.Constant(value: 2), Measurement(3, RPGMoney.Constant(value: 2)))
        ])
        func converted(
            _ measurement: Measurement<RPGMoney.Constant, Int>,
            to newUnit: RPGMoney.Constant,
            expected: Measurement<RPGMoney.Constant, Int>
        ) {
            let result = measurement.converted(to: newUnit, .base, .converter)
            #expect(result == expected)
        }
    }

    // MARK: Tagged (EX)
    struct TaggedTests {
        @Test("Uses static converter to change units")
        func converted() {
            let a = Tagged<RPGMoney.Zeni, Double>(15)
            #expect(a.converted(to: \.rpgMoney.gil) == Tagged<RPGMoney.Gil, Double>(45) )

            let b = Tagged<RPGMoney.Linen, Double>(9)
            #expect(b.converted(to: \.rpgMoney.gil) == Tagged<RPGMoney.Gil, Double>(25))

            let c = Tagged<RPGMoney.Zero, Double>(9)
            #expect(c.converted(to: \.rpgMoney.gil) == Tagged<RPGMoney.Gil, Double>(0))
        }
    }
}
