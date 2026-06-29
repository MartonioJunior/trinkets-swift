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
        @Measured(\.rpgMoney, in: { $0.constant(6) }) var money = 30
        #expect(type(of: money) == Int.self)
    }

    // MARK: Initializers
    @Test("Initializes with wrapped value in unit", arguments: [
        (32, RPGMoney.Constant(value: 4), Measurement(32, RPGMoney.Constant(value: 4))),
    ])
    func initializer(wrappedValue value: Int, in unit: RPGMoney.Constant, expected: Measurement<RPGMoney.Constant, Int>) {
        let result = Measured(wrappedValue: value, \.rpgMoney) { Tagged<RPGMoney, Int>.constant($0)(unit.value) }
        #expect(result.measurement == expected)
    }

    @Test("Returns value of Measurement", arguments: [
        (Measured(wrappedValue: 13, \.rpgMoney) { Tagged<RPGMoney, Int>.constant($0)(23) }, 13)
    ])
    func wrappedValueGet(_ sut: Measured<RPGMoney.Constant, Int>, expected: Int) {
        let result = sut.wrappedValue
        #expect(result == expected)
    }

    // MARK: Methods
    @Test("Converts given measure to the specified unit", arguments: [
        (
            Measured(wrappedValue: 13, \.rpgMoney) { $0.constant(23) },
            Measured(wrappedValue: -3, \.rpgMoney) { $0.constant(23) }
        )
    ])
    func setValue(_ sut: Measured<RPGMoney.Constant, Int>, expected: Measured<RPGMoney.Constant, Int>) {
        var resultA = sut
        resultA.setValue(Measurement(12, .init(value: 8)))
        #expect(resultA == expected)

        var resultB = sut
        resultB.setValue(Measurement(12, .init(value: 8)))
        #expect(resultB == expected)

        var resultC = sut
        resultC.setValue(Tagged<RPGMoney, Int>(20))
        #expect(resultC == expected)

        var resultD = sut
        resultD.setValue(Tagged<RPGMoney.Gil, Int>(20).rpgMoney)
        #expect(resultD == expected)
    }
}
