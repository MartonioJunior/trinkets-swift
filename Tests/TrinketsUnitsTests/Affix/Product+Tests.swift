//
//  Fraction+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Testing
@testable import TrinketsUnits

struct ProductTests {
    typealias Mock = Product<Gil, RefreshRate>

    @Test("Creates new product of two Units", arguments: [
        (Gil.in(.gil), RefreshRate.in(.fps))
    ])
    func initializer(_ lhs: Unit<Gil>, _ rhs: Unit<RefreshRate>) {
        let result = Product(lhs, rhs)
        #expect(result.lhs == lhs)
        #expect(result.rhs == rhs)
    }

    @Test("Swaps units around", arguments: [
        (Product(.zeni, .fps), Product(.fps, .zeni))
    ])
    func flipped(_ sut: Mock, expected: Mock.Flipped) {
        let result = sut.flipped
        #expect(result == expected)
    }

    // MARK: Self: Dimension
    struct ConformsToDimension {
        @Test("Returns product of base units")
        func baseUnit() {
            let expected = Mock.Unit("g-fps", details: .init(.gil, .fps))
            #expect(Mock.baseUnit == expected)
        }

        @Test("Returns combined dimensions of it's factors")
        func dimensionality() {
            let expected: Dimensionality = [Gil.self: 1, RefreshRate.self: 1]
            #expect(Mock.dimensionality == expected)
        }

        @Test("Returns base value using the function x left * 1 right", arguments: [
            (5, Gil.in(.zeni)(.fps), 15),
            (0, Gil.in(.gil)(.cinema), 0),
            (-6, Gil.in(.linen)(.cinema), -120),
            (0, Gil.in(.linen)(.cinema), 168),
            (7, Mock.baseUnit, 7)
        ])
        func baseValue(of value: Mock.Value, _ unit: Mock.Unit, expected: Mock.Value) {
            let result = Mock.baseValue(of: value, unit)
            #expect(result == expected)
        }

        @Test("Converts base value using right, then left factors", arguments: [
            (15, Gil.in(.zeni)(.fps), 5),
            (0, Gil.in(.gil)(.cinema), 0),
            (48, Gil.in(.linen)(.fps), 20.5),
            (0, Gil.in(.linen)(.cinema), -3.5),
            (7, Mock.baseUnit, 7)
        ])
        func convert(_ baseValue: Mock.Value, to unit: Mock.Unit, expected: Mock.Value) {
            let result = Mock.convert(baseValue, to: unit)
            #expect(result == expected)
        }
    }

    // MARK: Unit (EX)
    @Test("Defines valid syntax for creating units based on PRoduct", arguments: [
        (Gil.in(.zeni)(.fps), "z-fps", Product(.zeni, .fps)),
        (Gil.in(.linen) * RefreshRate.in(.fps), "ln-fps", Product(.linen, .fps)),
        (Unit(.gil, .cinema), "g-24fps", Product(.gil, .cinema)),
        (Unit(Product(.linen, .cinema)), "ln-24fps", Product(.linen, .cinema)),
        (Product(.zeni, .cinema).asUnit, "z-24fps", Product(.zeni, .cinema))
    ])
    func syntax(
        _ compositeUnit: Unit<Mock>,
        expectedSymbol: Mock.Symbol,
        expectedFeatures: Mock
    ) {
        #expect(compositeUnit.symbol == expectedSymbol)
        #expect(compositeUnit.features == expectedFeatures)
    }
}
