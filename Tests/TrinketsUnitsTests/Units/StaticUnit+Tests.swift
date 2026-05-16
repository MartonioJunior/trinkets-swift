//
//  StaticUnit+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/05/2026.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct StaticUnitTests {
    @Test("Describes use cases for the type")
    func syntax() {
        let staticMeasure = Tagged<RPGMoney.Zeni, Double>(40)
        #expect(type(of: staticMeasure.converted(.to, .linen)) == Tagged<RPGMoney.Linen, Double>.self)
        #expect(type(of: RPGMoney.of(25, .gil)) == Tagged<RPGMoney.Gil, Int>.self)
        #expect(type(of: RPGMoney.in(.linen)) == RPGMoney.Linen.Type.self)

        let measurer = RPGMoney.measure(String.self, in: .gil) { $0.count }
        #expect(type(of: measurer("banana")) == Tagged<RPGMoney.Gil, Int>.self)
    }
}
