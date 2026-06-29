//
//  ProductUnit+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct ProductUnitTests {
    // MARK: Syntax
    @Test("Evaluates use cases for the type")
    func syntax() {
        typealias MoneyFrames<T> = Tagged<ProductUnit<RPGMoney, RefreshRate>, T>

        #expect(type(of: ProductUnit(RPGMoney.Constant(value: 3), RefreshRate.FPS(refreshRate: 60))) == ProductUnit<RPGMoney.Constant, RefreshRate.FPS>.self)
        #expect(type(of: MoneyFrames<Double>.in(\.zeni, \.cinema)) == Tagged<ProductUnit<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.Type.self)
        #expect(type(of: ProductUnit.of(25, \.zeni, \.cinema)) == Tagged<ProductUnit<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.self)
        #expect(type(of: Tagged<RPGMoney, Double>.in(\.zeni).times(\.cinema)) == Tagged<ProductUnit<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.Type.self)
        #expect(type(of: Tagged<_, Double>.in(\.zeni, \.cinema)) == Tagged<ProductUnit<RPGMoney.Zeni, RefreshRate.Cinema>, Double>.Type.self)
        #expect(type(of: RPGMoney.Zeni.times(RefreshRate.Cinema.self)) == ProductUnit<RPGMoney.Zeni, RefreshRate.Cinema>.Type.self)
        #expect(type(of: RPGMoney.Zeni.times(RefreshRate.self)) == ProductUnit<RPGMoney.Zeni, RefreshRate>.Type.self)
        #expect(type(of: Tagged<_, Double>.in(\.zeni).times(RefreshRate.self)) == Tagged<ProductUnit<RPGMoney.Zeni, RefreshRate>, Double>.Type.self)
        #expect(type(of: RPGMoney.times(RefreshRate.Cinema.self)) == ProductUnit<RPGMoney, RefreshRate.Cinema>.Type.self)
        #expect(type(of: RPGMoney.times(RefreshRate.self)) == ProductUnit<RPGMoney, RefreshRate>.Type.self)
    }

    // MARK: Initializers
    @Test("Creates new product of two Units", arguments: [
        (RPGMoney.Constant(value: 2), RefreshRate.FPS(refreshRate: 30))
    ])
    func initializer(_ lhs: RPGMoney.Constant, _ rhs: RefreshRate.FPS) {
        let result = ProductUnit(lhs, rhs)
        #expect(result.lhs == lhs)
        #expect(result.rhs == rhs)
    }

    @Test("Swaps units around", arguments: [
        (
            ProductUnit(RPGMoney.Constant(value: 3), RefreshRate.FPS(refreshRate: 60)),
            ProductUnit(RefreshRate.FPS(refreshRate: 60), RPGMoney.Constant(value: 3))
        )
    ])
    func flipped(_ sut: ProductUnit<RPGMoney.Constant, RefreshRate.FPS>, expected: ProductUnit<RefreshRate.FPS, RPGMoney.Constant>) {
        let result = sut.flipped
        #expect(result == expected)
        #expect(ProductUnit<RPGMoney.Constant, RefreshRate.FPS>.Flipped.self == ProductUnit<RefreshRate.FPS, RPGMoney.Constant>.self)
    }

    // MARK: Self: Convertible
    struct ConformsToConvertible {
        @Test("Defines the converter base as the product of it's elements' base")
        func baseType() {
            #expect(ProductUnit<RPGMoney.Gil, RefreshRate.Cinema>.Base.self == ProductUnit<RPGMoney, RefreshRate>.self)
        }
    }
    
    // MARK: Self: CustomStringConvertible
    struct ConformsToCustomStringConvertible {
        @Test("Defines valid syntax for creating units based on Product", arguments: [
            (ProductUnit(RPGMoney.Constant(value: 9), RefreshRate.FPS(refreshRate: 60)), "9$-60fps")
        ])
        func description(_ sut: ProductUnit<RPGMoney.Constant, RefreshRate.FPS>, expected: String) {
            #expect(sut.description == expected)
        }
    }

    // MARK: Self: Dimension
    struct ConformsToDimension {
        @Test("Returns product of base units")
        func baseUnit() {
            #expect(ProductUnit<RPGMoney.Gil, RefreshRate.Cinema>.Base.self == ProductUnit<RPGMoney, RefreshRate>.self)
        }

        @Test("Returns combined dimensions of it's factors")
        func dimensionality() {
            let expected: Dimensionality = [RPGMoney.self: 1, RefreshRate.self: 1]
            #expect(ProductUnit<RPGMoney, RefreshRate>.dimensionality == expected)
        }
    }

    // MARK: Tagged (EX)
    @Test("Returns base value using left, then right factors")
    func baseValue() {
        let a = Tagged<ProductUnit<RPGMoney.Zeni, RefreshRate.Cinema>, Double>(5)
        #expect(a.second(\.refreshRate, then: \.rpgMoney) == 360)
        #expect(a.first(\.rpgMoney, then: \.refreshRate) == 360)

        let b = Tagged<ProductUnit<RPGMoney.Gil, RefreshRate.Cinema>, Double>(0)
        #expect(b.second(\.refreshRate, then: \.rpgMoney) == 0)
        #expect(b.first(\.rpgMoney, then: \.refreshRate) == 0)

        let c = Tagged<ProductUnit<RPGMoney.Linen, RefreshRate.Cinema>, Double>(-6)
        #expect(c.second(\.refreshRate, then: \.rpgMoney) == -281)
        #expect(c.first(\.rpgMoney, then: \.refreshRate) == -120)

        let d = Tagged<ProductUnit<RPGMoney.Linen, RefreshRate.Cinema>, Double>(0)
        #expect(d.second(\.refreshRate, then: \.rpgMoney) == 7)
        #expect(d.first(\.rpgMoney, then: \.refreshRate) == 168)
    }

    @Test("Converts base value using right, then left factors")
    func converted() {
        let a = Tagged<ProductUnit<RPGMoney, RefreshRate>, Double>(180)
        #expect(a.second(\.cinema, then: \.zeni) == 2.5)
        #expect(a.first(\.zeni, then: \.cinema) == 2.5)

        let b = Tagged<ProductUnit<RPGMoney, RefreshRate>, Double>(0)
        #expect(b.second(\.cinema, then: \.gil) == 0)
        #expect(b.first(\.gil, then: \.cinema) == 0)

        let c = Tagged<ProductUnit<RPGMoney, RefreshRate>, Double>(60)
        #expect(c.second(\.cinema, then: \.zero) == 0)
        #expect(c.first(\.zero, then: \.cinema) == 0)

        let d = Tagged<ProductUnit<RPGMoney, RefreshRate>, Double>(0)
        #expect(d.second(\.cinema, then: \.linen) == -3.5)
        #expect(d.first(\.linen, then: \.cinema) == -0.14583333333333334)
    }
}
