//
//  Measured+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 02/09/25.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct MeasuredTests {
    // MARK: Syntax
    @Test("Allows using it using the following syntax")
    func syntax() {
        let dynamicUnit = RPGMoney.Constant(value: 6)
        @Measured(in: dynamicUnit, .base, .converter) var money = 30
        #expect(type(of: money) == Measurement<RPGMoney.Constant, Int>.self)
    }

    // MARK: Initializers
    @Test("Initializes with wrapped value in unit", arguments: [
        (32, RPGMoney.Constant(value: 4), Measurement(32, RPGMoney.Constant(value: 4))),
    ])
    func initializer(wrappedValue value: Int, in unit: RPGMoney.Constant, expected: Measurement<RPGMoney.Constant, Int>) {
        let result = Measured(wrappedValue: value, in: unit, .base, .converter)
        #expect(result.measurement == expected)
    }

    @Test("Returns value of Measurement", arguments: [
        (
            Measured(wrappedValue: 13, in: RPGMoney.Constant(value: 23), .base, .converter),
            Measurement(13, RPGMoney.Constant(value: 23))
        )
    ])
    func wrappedValueGet(_ sut: Measured<RPGMoney.Constant, Int>, expected: Measurement<RPGMoney.Constant, Int>) {
        let result = sut.wrappedValue
        #expect(result == expected)
    }

    // MARK: Methods
    @Test("Converts given measure to the specified unit", arguments: [
        (
            Measured(wrappedValue: 13, in: RPGMoney.Constant(value: 23), .base, .converter),
            Measured(wrappedValue: -3, in: RPGMoney.Constant(value: 23), .base, .converter)
        )
    ])
    func setValue(_ sut:  Measured<RPGMoney.Constant, Int>, expected:  Measured<RPGMoney.Constant, Int>) {
        var resultA = sut
        resultA.wrappedValue = Measurement(12, .init(value: 8))
        #expect(resultA == expected)

        var resultB = sut
        resultB.setValue(Measurement(12, .init(value: 8)))
        #expect(resultB == expected)

        var resultC = sut
        resultC.setValue(Tagged<RPGMoney, Int>(20))
        #expect(resultC == expected)

        var resultD = sut
        resultD.setValue(Tagged<RPGMoney.Gil, Int>(20), .to)
        #expect(resultD == expected)
    }
}
