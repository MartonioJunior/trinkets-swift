//
//  Measurable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/05/2026.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct MeasurableTests {
    // MARK: Syntax
    @Test("Evaluates use cases for the type")
    func syntax() {
        let staticUnit = RPGMoney.Gil.self
        #expect(type(of: staticUnit.x(50)) == Tagged<RPGMoney.Gil, Int>.self)
        #expect(type(of: staticUnit * 50) == Tagged<RPGMoney.Gil, Int>.self)
        #expect(type(of: 50 * staticUnit) == Tagged<RPGMoney.Gil, Int>.self)
        let staticMeasurer = staticUnit.measure(String.self) { $0.count }
        #expect(type(of: staticMeasurer("lollipop")) == Tagged<RPGMoney.Gil, Int>.self)

        let dynamicUnit = RPGMoney.Constant(value: 0)
        #expect(type(of: dynamicUnit.x(50)) == Measurement<RPGMoney.Constant, Int>.self)
        #expect(type(of: dynamicUnit * 50) == Measurement<RPGMoney.Constant, Int>.self)
        #expect(type(of: 50 * dynamicUnit) == Measurement<RPGMoney.Constant, Int>.self)
        let dynamicMeasurer = RPGMoney.Constant.measure(String.self, in: dynamicUnit) { $0.count }
        #expect(type(of: dynamicMeasurer("lollipop")) == Measurement<RPGMoney.Constant, Int>.self)
    }
}
