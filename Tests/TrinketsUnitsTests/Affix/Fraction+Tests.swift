//
//  Fraction+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

import Testing
@testable import TrinketsUnits

struct FractionTests {
    typealias Mock = Fraction<Gil, RefreshRate>

    @Test("Creates new fraction with units", arguments: [
        (Gil.in(.zeni), RefreshRate.in(.fps))
    ])
    func initializer(_ numerator: Unit<Gil>, per denominator: Unit<RefreshRate>) {
        let result = Fraction(numerator, per: denominator)
        #expect(result.numerator == numerator)
        #expect(result.denominator == denominator)
    }

    @Test("Swaps places of numerator and denominator", arguments: [
        (Fraction(.linen, per: .fps), Fraction(.fps, per: .linen))
    ])
    func flipped(_ sut: Mock, expected: Mock.Flipped) {
        let result = sut.flipped
        #expect(result == expected)
    }

    // MARK: Self: Dimension
    struct ConformsToDimension {
        @Test("Returns a composite unit based on the base units of both components")
        func baseUnit() {
            let expected = Unit<Mock>("g/fps", details: .init(.gil, per: .fps))
            #expect(Mock.baseUnit == expected)
        }

        @Test("Returns the composed dimensionality of the fraction")
        func dimensionality() {
            let expected: Dimensionality = [Gil.self: 1, RefreshRate.self: -1]
            #expect(Mock.dimensionality == expected)
        }

        @Test("Converts value using as x numerator / 1 denominator", arguments: [
            (10, Gil.in(.linen).per(.fps), 27),
            (8, Gil.in(.zeni).per(.cinema), 1),
            (0, Gil.in(.zeni).per(.cinema), 0),
            (16, Gil.in(.linen).per(.cinema), 1.625),
            (0, Gil.in(.linen).per(.fps), 7),
            (35, Mock.baseUnit, 35)
        ])
        func baseValue(of value: Mock.Value, _ unit: Mock.Unit, expected: Mock.Value) {
            let result = Mock.baseValue(of: value, unit)
            #expect(result == expected)
        }

        @Test("Converts base value using denominator, then numerator", arguments: [
            (12, Gil.in(.gil).per(.cinema), 288),
            (15, Gil.in(.zeni).per(.fps), 5),
            (0, Gil.in(.zeni).per(.fps), 0),
            (2, Gil.in(.linen).per(.cinema), 20.5),
            (0, Gil.in(.linen).per(.cinema), -3.5),
            (500, Mock.baseUnit, 500)
        ])
        func convert(_ baseValue: Mock.Value, to unit: Mock.Unit, expected: Mock.Value) {
            let result = Mock.convert(baseValue, to: unit)
            #expect(result == expected)
        }
    }

    // MARK: Unit (EX)
    @Test("Defines valid syntax for creating units based on Fraction", arguments: [
        (Gil.in(.zeni).per(.fps), "z/fps", Fraction(.zeni, per: .fps)),
        (Gil.in(.linen) / RefreshRate.in(.cinema), "ln/24fps", Fraction(.linen, per: .cinema)),
        (Unit(.gil, per: .cinema), "g/24fps", Fraction(.gil, per: .cinema)),
        (Unit(Fraction(.gil, per: .fps)), "g/fps", Fraction(.gil, per: .fps)),
        (Fraction(.linen, per: .fps).asUnit, "ln/fps", Fraction(.linen, per: .fps))
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
