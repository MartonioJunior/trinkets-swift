//
//  UnitPrefix+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2025.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct UnitPrefixTests {
    // MARK: Syntax
    @Test("Defines use cases for the type")
    func syntax() {
        #expect(type(of: RPGMoney.in(.tubular, RPGMoney.Constant(value: 7))) == PrefixedUnit<SlangPrefix.Tubular, RPGMoney.Constant>.self)
        #expect(type(of: RPGMoney.of(25, .whoa, RPGMoney.Constant(value: 7))) == Measurement<PrefixedUnit<SlangPrefix.Whoa, RPGMoney.Constant>, Int>.self)

        #expect(type(of: RPGMoney.in(.tubular, .zeni)) == PrefixedUnit<SlangPrefix.Tubular, RPGMoney.Zeni>.Type.self)
        #expect(type(of: RPGMoney.of(25, .whoa, .zero)) == Tagged<PrefixedUnit<SlangPrefix.Whoa, RPGMoney.Zero>, Int>.self)
    }

    // MARK: Default Implementation
    @Test("Compares multipliers with no participation of symbol")
    func lesserThan() {
        let a = SlangPrefix.Tubular.self < SlangPrefix.Whoa.self
        #expect(a == true)

        let b = SlangPrefix.Whoa.self < SlangPrefix.Tubular.self
        #expect(b == false)

        let c = SlangPrefix.Whoa.self < SlangPrefix.Whoa.self
        #expect(c == false)
    }
}
