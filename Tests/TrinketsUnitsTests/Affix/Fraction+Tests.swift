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
        typealias MoneyPerFrame<T> = Tagged<Fraction<RPGMoney, RefreshRate>, T>

        #expect(type(of: Fraction(RefreshRate.FPS(refreshRate: 24), per: RPGMoney.Constant(value: 12))) == Fraction<RefreshRate.FPS, RPGMoney.Constant>.self)
        #expect(type(of: MoneyPerFrame<Double>.in(\.zeni, per: \.cinema)) == Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.Type.self)
        #expect(type(of: Fraction.of(25, \.zeni, per: \.cinema)) == Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.self)
        #expect(type(of: Tagged<RPGMoney, Double>.in(\.zeni).per(\.cinema)) == Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.Type.self)
        #expect(type(of: Tagged<_, Double>.in(\.zeni, per: \.cinema)) == Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.Type.self)
        #expect(type(of: RPGMoney.Zeni.per(RefreshRate.Cinema.self)) == Fraction<RPGMoney.Zeni, RefreshRate.Cinema>.Type.self)
        #expect(type(of: RPGMoney.Zeni.per(RefreshRate.self)) == Fraction<RPGMoney.Zeni, RefreshRate>.Type.self)
        #expect(type(of: Tagged<_, Double>.in(\.zeni).per(RefreshRate.self)) == Tagged<Fraction<RPGMoney.Zeni, RefreshRate>, Double>.Type.self)
        #expect(type(of: RPGMoney.per(RefreshRate.Cinema.self)) == Fraction<RPGMoney, RefreshRate.Cinema>.Type.self)
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
        #expect(a.numerator(\.rpgMoney, then: \.refreshRate) == 648)
        #expect(a.denominator(\.refreshRate, then: \.rpgMoney) == 487)

        let b = Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>(432)
        #expect(b.numerator(\.rpgMoney, then: \.refreshRate) == 31104)
        #expect(b.denominator(\.refreshRate, then: \.rpgMoney) == 31104)

        let c = Tagged<Fraction<RPGMoney.Zeni, RefreshRate.Cinema>, Double>(0)
        #expect(c.numerator(\.rpgMoney, then: \.refreshRate) == 0)
        #expect(c.denominator(\.refreshRate, then: \.rpgMoney) == 0)

        let d = Tagged<Fraction<RPGMoney.Linen, RefreshRate.Cinema>, Double>(20.5)
        #expect(d.numerator(\.rpgMoney, then: \.refreshRate) == 1152)
        #expect(d.denominator(\.refreshRate, then: \.rpgMoney) == 991)

        let e = Tagged<Fraction<RPGMoney.Linen, RefreshRate.Cinema>, Double>(-7)
        #expect(e.numerator(\.rpgMoney, then: \.refreshRate) == -168)
        #expect(e.denominator(\.refreshRate, then: \.rpgMoney) == -329)
    }

    @Test("Returns base value using denominator, then numerator")
    func converted() {
        let a = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(12)
        #expect(a.numerator(\.gil, then: \.cinema) == 0.5)
        #expect(a.denominator(\.cinema, then: \.gil) == 0.5)

        let b = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(360)
        #expect(b.numerator(\.zeni, then: \.cinema) == 5)
        #expect(b.denominator(\.cinema, then: \.zeni) == 5)

        let c = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(0)
        #expect(c.numerator(\.zeni, then: \.cinema) == 0)
        #expect(c.denominator(\.cinema, then: \.zeni) == 0)

        let d = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(72)
        #expect(d.numerator(\.linen, then: \.cinema) == 1.3541666666666667)
        #expect(d.denominator(\.cinema, then: \.linen) == -2)

        let e = Tagged<Fraction<RPGMoney, RefreshRate>, Double>(0)
        #expect(e.numerator(\.linen, then: \.cinema) == -0.14583333333333334)
        #expect(e.denominator(\.cinema, then: \.linen) == -3.5)
    }
}
