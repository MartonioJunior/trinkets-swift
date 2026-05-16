//
//  Fraction+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct FractionTests {
    // MARK: Syntax
    @Test("Evaluates use cases for the type")
    func syntax() {
        #expect(type(of: Fraction(RefreshRate.FPS(refreshRate: 24), per: RPGMoney.Constant(value: 12))) == Fraction<RefreshRate.FPS, RPGMoney.Constant>.self)

        #expect(type(of: Fraction.of(.zeni, per: .cinema)) == Fraction<RPGMoney.Zeni, RefreshRate.Cinema>.Type.self)
        #expect(type(of: RPGMoney.in(.zeni).per(.cinema)) == Tagged<Fraction<RPGMoney, RefreshRate>, Fraction<RPGMoney.Zeni, RefreshRate.Cinema>.Type>.self)
        #expect(type(of: RPGMoney.Zeni.per(.cinema)) == Tagged<Fraction<RPGMoney, RefreshRate>, Fraction<RPGMoney.Zeni, RefreshRate.Cinema>.Type>.self)
        #expect(type(of: Tagged.fraction(.zeni, per: .cinema)) == Tagged<Fraction<RPGMoney, RefreshRate>, Fraction<RPGMoney.Zeni, RefreshRate.Cinema>.Type>.self)
        #expect(type(of: RPGMoney.Zeni.per(RefreshRate.self)) == Tagged<Fraction<RPGMoney, RefreshRate>, Fraction<RPGMoney.Zeni, RefreshRate>.Type>.self)
        #expect(type(of: RPGMoney.in(.zeni).per(RefreshRate.self)) == Tagged<Fraction<RPGMoney, RefreshRate>, Fraction<RPGMoney.Zeni, RefreshRate>.Type>.self)
        #expect(type(of: RPGMoney.per(.cinema)) == Tagged<Fraction<RPGMoney, RefreshRate>, Fraction<RPGMoney, RefreshRate.Cinema>.Type>.self)
        #expect(type(of: RPGMoney.per(RefreshRate.self)) == Fraction<RPGMoney, RefreshRate>.Type.self)
    }

    // MARK: Initializers
    @Test("Creates new fraction with units", arguments: [
        (RPGMoney.Constant(value: 9), RefreshRate.FPS(refreshRate: 12))
    ])
    func initializer(_ numerator: RPGMoney.Constant, per denominator: RefreshRate.FPS) {
        let result = Fraction(numerator, per: denominator)
        #expect(result.numerator == numerator)
        #expect(result.denominator == denominator)
    }

    @Test("Swaps places of numerator and denominator", arguments: [
        (
            Fraction(RPGMoney.Constant(value: 9), per: RefreshRate.FPS(refreshRate: 12)),
            Fraction(RefreshRate.FPS(refreshRate: 12), per: RPGMoney.Constant(value: 9))
        )
    ])
    func flipped(_ sut: Fraction<RPGMoney.Constant, RefreshRate.FPS>, expected: Fraction<RefreshRate.FPS, RPGMoney.Constant>) {
        let result = sut.flipped
        #expect(result == expected)
        #expect(Fraction<RPGMoney.Constant, RefreshRate.FPS>.Flipped.self == Fraction<RefreshRate.FPS, RPGMoney.Constant>.self)
    }

    // MARK: Self: Convertible
    struct ConformsToConvertible {
        @Test("Defines the converter base as the fraction of it's elements' base")
        func baseType() {
            #expect(Fraction<RPGMoney.Gil, RefreshRate.Cinema>.Base.self == Fraction<RPGMoney, RefreshRate>.self)
        }
    }

    // MARK: Self: CustomStringConvertible
    struct ConformsToCustomStringConvertible {
        @Test("Defines valid syntax for creating units based on Fraction", arguments: [
            (Fraction(RPGMoney.Constant(value: 9), per: RefreshRate.FPS(refreshRate: 60)), "9$/60fps")
        ])
        func description(_ sut: Fraction<RPGMoney.Constant, RefreshRate.FPS>, expected: String) {
            #expect(sut.description == expected)
        }
    }

    // MARK: Self: Dimension
    struct ConformsToDimension {
        @Test("Returns a composite unit based on the base units of both components")
        func baseUnit() {
            #expect(Fraction<RPGMoney.Gil, RefreshRate.Cinema>.Base.self == Fraction<RPGMoney, RefreshRate>.self)
        }

        @Test("Returns the composed dimensionality of the fraction")
        func dimensionality() {
            let expected: Dimensionality = [RPGMoney.self: 1, RefreshRate.self: -1]
            #expect(Fraction<RPGMoney, RefreshRate>.dimensionality == expected)
        }
    }

    // MARK: Tagged (EX)
    @Test("Returns base value using numerator, then denominator")
    func baseValue() {
        let a = Tagged<Fraction<RPGMoney.Linen, RefreshRate.Cinema>, Double>(10)
        #expect(a.baseValue(.numeratorFirst(.to, then: .to)) == 648)
        #expect(a.baseValue(.denominatorFirst(.to, then: .to)) == 487)

        let b = Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>(432)
        #expect(b.baseValue(.numeratorFirst(.to, then: .to)) == 31104)
        #expect(b.baseValue(.denominatorFirst(.to, then: .to)) == 31104)

        let c = Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>(0)
        #expect(c.baseValue(.numeratorFirst(.to, then: .to)) == 0)
        #expect(c.baseValue(.denominatorFirst(.to, then: .to)) == 0)

        let d = Tagged<Fraction<RPGMoney.Linen, RefreshRate.Cinema>, Double>(20.5)
        #expect(d.baseValue(.numeratorFirst(.to, then: .to)) == 1152)
        #expect(d.baseValue(.denominatorFirst(.to, then: .to)) == 991)

        let e = Tagged<Fraction<RPGMoney.Linen, RefreshRate.Cinema>, Double>(-7)
        #expect(e.baseValue(.numeratorFirst(.to, then: .to)) == -168)
        #expect(e.baseValue(.denominatorFirst(.to, then: .to)) == -329)
    }

    @Test("Returns base value using denominator, then numerator")
    func converted() {
        let a = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(12)
        #expect(a.converted(to: .numeratorFirst(.gil, then: .cinema)) == 0.5)
        #expect(a.converted(to: .denominatorFirst(.cinema, then: .gil)) == 0.5)

        let b = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(360)
        #expect(b.converted(to: .numeratorFirst(.zeni, then: .cinema)) == 5)
        #expect(b.converted(to: .denominatorFirst(.cinema, then: .zeni)) == 5)

        let c = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(0)
        #expect(c.converted(to: .numeratorFirst(.zeni, then: .cinema)) == 0)
        #expect(c.converted(to: .denominatorFirst(.cinema, then: .zeni)) == 0)

        let d = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(72)
        #expect(d.converted(to: .numeratorFirst(.linen, then: .cinema)) == 1.3541666666666667)
        #expect(d.converted(to: .denominatorFirst(.cinema, then: .linen)) == -2)

        let e = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(0)
        #expect(e.converted(to: .numeratorFirst(.linen, then: .cinema)) == -0.14583333333333334)
        #expect(e.converted(to: .denominatorFirst(.cinema, then: .linen)) == -3.5)
    }
}
