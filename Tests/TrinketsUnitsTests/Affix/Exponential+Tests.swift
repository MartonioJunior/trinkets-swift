//
//  Exponential+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2025.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct ExponentialTests {
    @available(macOS 26.0, *)
    public typealias Mock = Exponential<RPGMoney, 2>

    // MARK: Syntax
    @available(macOS 26.0, *)
    @Test("Evaluates use cases for the type")
    func syntax() {
        let dynamicUnit = RPGMoney.Constant(value: 12)

        #expect(type(of: Exponential.square(dynamicUnit)) == Square<RPGMoney.Constant>.self)
        #expect(type(of: Exponential.cubic(dynamicUnit)) == Cubic<RPGMoney.Constant>.self)
        #expect(type(of: Exponential<_, 6>(dynamicUnit)) == Exponential<RPGMoney.Constant, 6>.self)
        #expect(type(of: Tagged<_, Double>.square(\.zeni)) == Tagged<Square<RPGMoney.Zeni>, Double>.Type.self)
        #expect(type(of: Tagged<_, Double>.cubic(\.zeni)) == Tagged<Cubic<RPGMoney.Zeni>, Double>.Type.self)
        #expect(type(of: Tagged<Exponential<_, 4>, Double>.in(\.zeni)) == Tagged<Exponential<RPGMoney.Zeni, 4>, Double>.Type.self)

        #expect(type(of: Measurement(25, dynamicUnit.squared)) == Measurement<Square<RPGMoney.Constant>, Int>.self)
        #expect(type(of: Measurement(25, dynamicUnit.cubic)) == Measurement<Cubic<RPGMoney.Constant>, Int>.self)
        #expect(type(of: Measurement(25, Exponential<_, 6>(dynamicUnit))) == Measurement<Exponential<RPGMoney.Constant, 6>, Int>.self)
        #expect(type(of: Exponential.of(25, \.squared, \.zeni)) == Tagged<Exponential<RPGMoney.Zeni, 2>, Double>.self)
        #expect(type(of: Exponential.of(25, \.cubic, \.zeni)) == Tagged<Exponential<RPGMoney.Zeni, 3>, Double>.self)
        #expect(type(of: Exponential<_, 4>.of(25, \.zeni)) == Tagged<Exponential<RPGMoney.Zeni, 4>, Double>.self)

        #expect(type(of: Tagged<RPGMoney.Zeni, Int>.E<4>(25)) == Tagged<Exponential<RPGMoney.Zeni, 4>, Int>.self)
    }

    // MARK: Initializers
    @available(macOS 26.0, *)
    @Test("Creates a new exponential unit with the specified factor", arguments: [
        RPGMoney.Constant(value: 3)
    ])
    func initializer(_ unit: RPGMoney.Constant) {
        let result = Exponential<RPGMoney.Constant, 3>(unit)
        #expect(result.base == unit)
        #expect(result.exponent == 3)
    }

    // MARK: N == 0
    @available(macOS 26.0, *)
    @Test("Transforms exponent 0 back into a value")
    func unwrapValue() {
        let dynamicUnit = RPGMoney.Constant(value: 12)
        let linearUnit = Unitless(dynamicUnit)
        let dynamicMeasure = Measurement(15, linearUnit)
        #expect(dynamicMeasure.unwrapValue() == 15)

        let staticMeasure = Tagged<Unitless<RPGMoney.Zeni>, Int>(8)
        #expect(staticMeasure.unwrapValue() == 8)
    }

    // MARK: N == 1
    @available(macOS 26.0, *)
    @Test("Transforms exponent 1 back into a normal unit")
    func unwrapMeasure() {
        let dynamicUnit = RPGMoney.Constant(value: 12)
        let linearUnit = Linear(dynamicUnit)
        let dynamicMeasure = Measurement(15, linearUnit)
        #expect(dynamicMeasure.unwrapMeasure() == Measurement(15, dynamicUnit))

        let staticMeasure = Tagged<Linear<RPGMoney.Zeni>, Int>(8)
        #expect(staticMeasure.unwrapMeasure() == Tagged<RPGMoney.Zeni, Int>(8))
    }

    // MARK: Self: Dimension
    struct ConformsToDimension {
        @available(macOS 26.0, *)
        @Test("Defined as base unit, elevated to the Nth power")
        func baseUnit() {
            #expect(Exponential<RPGMoney.Zero, 4>.Base.self == Exponential<RPGMoney, 4>.self)
        }

        @available(macOS 26.0, *)
        @Test("Defined by exponent * baseUnit's dimensionality")
        func dimensionality() {
            let result = Exponential<RPGMoney, 6>.dimensionality
            let expected: Dimensionality = [RPGMoney.self: 6]
            #expect(result == expected)
        }
    }

    // MARK: Measurable (EX)
    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 2nd power", arguments: [
        (RPGMoney.Constant(value: 21), Square(RPGMoney.Constant(value: 21)))
    ])
    func squared(_ sut: RPGMoney.Constant, expected: Square<RPGMoney.Constant>) {
        let result = sut.squared
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 3nd power", arguments: [
        (RPGMoney.Constant(value: 12), Cubic(RPGMoney.Constant(value: 12)))
    ])
    func cubic(_ sut: RPGMoney.Constant, expected: Cubic<RPGMoney.Constant>) {
        let result = sut.cubic
        #expect(result == expected)
    }
}

// MARK: Tagged (EX)
extension ExponentialTests {
    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 2nd power")
    func square() {
        let result = Tagged<_, Double>.square(\.zero)
        let expected = Tagged<Square<RPGMoney.Zero>, Double>.self
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 3nd power")
    func cubic() {
        let result = Tagged<_, Double>.cubic(\.zero)
        let expected = Tagged<Cubic<RPGMoney.Zero>, Double>.self
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Returns base amount from exponential unit")
    func pow() {
        let a = Tagged<Square<RPGMoney>, Double>(10)
        #expect(a.pow() == Tagged<RPGMoney, Double>(100))

        let b = Tagged<Cubic<RPGMoney>, Double>(-4)
        #expect(b.pow() == Tagged<RPGMoney, Double>(-64))

        let c = Tagged<Exponential<RPGMoney, 5>, Double>(2)
        #expect(c.pow() == Tagged<RPGMoney, Double>(32))
    }

    @available(macOS 26.0, *)
    @Test("Returns base amount from exponential unit")
    func powConverter() {
        let a = Tagged<Square<RPGMoney.Gil>, Double>(10)
        #expect(a.pow(\.rpgMoney) == Tagged<RPGMoney, Double>(100))

        let b = Tagged<Square<RPGMoney.Gil>, Double>(-4)
        #expect(b.pow(\.rpgMoney) == Tagged<RPGMoney, Double>(16))

        let c = Tagged<Square<RPGMoney.Zeni>, Double>(5)
        #expect(c.pow(\.rpgMoney) == Tagged<RPGMoney, Double>(225))

        let d = Tagged<Square<RPGMoney.Linen>, Double>(13)
        #expect(d.pow(\.rpgMoney) == Tagged<RPGMoney, Double>(1089))
    }

    @available(macOS 26.0, *)
    @Test("Defines exponential amount from base amount")
    func root() {
        let a = Tagged<RPGMoney, Double>(49)
        #expect(a.root() == Tagged<Square<RPGMoney>, Double>(7))

        let b = Tagged<RPGMoney, Double>(125)
        #expect(b.root() == Tagged<Cubic<RPGMoney>, Double>(5))

        let c = Tagged<RPGMoney, Double>(64)
        #expect(c.root() == Tagged<Exponential<RPGMoney, 6>, Double>(2))
    }

    @available(macOS 26.0, *)
    @Test("Defines exponential amount from base amount")
    func rootConverter() {
        let a = Tagged<RPGMoney, Double>(49)
        #expect(a.root(\.gil) == Tagged<Square<RPGMoney.Gil>, Double>(7))

        let b = Tagged<RPGMoney, Double>(225)
        #expect(b.root(\.zeni) == Tagged<Square<RPGMoney.Zeni>, Double>(5))

        let c = Tagged<RPGMoney, Double>(64)
        #expect(c.root(\.gil) == Tagged<Cubic<RPGMoney.Gil>, Double>(4))
    }
}
