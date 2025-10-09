//
//  Exponential+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2025.
//

import Testing
@testable import TrinketsUnits

struct ExponentialTests {
    @available(macOS 26.0, *)
    public typealias Mock = Exponential<Gil, 2>

    @available(macOS 26.0, *)
    @Test("Creates a new exponential unit with the specified factor", arguments: [
        Gil.baseUnit
    ])
    func initializer(_ unit: Unit<Gil>) {
        let result = Exponential<Gil, 3>(unit)
        #expect(result.unit == unit)
        #expect(result.exponent == 3)
    }

    // MARK: Self: Dimension
    struct ConformsToDimension {
        @available(macOS 26.0, *)
        @Test("Defined as base unit, elevated to the Nth power")
        func baseUnit() {
            let result = Exponential<Gil, 4>.baseUnit
            let expected: Unit<Exponential<Gil, 4>> = Gil.baseUnit.pow()
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Defined by exponent * baseUnit's dimensionality")
        func dimensionality() {
            let result = Exponential<Gil, 6>.dimensionality
            let expected: Dimensionality = [Gil.self: 6]
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Defined by exponent * baseUnit's dimensionality", arguments: [
            (10, Gil.baseUnit.squared, 100),
            (-4, Gil.baseUnit.squared, 16),
            (5, Gil.in(.zeni).squared, 225),
            (13, Gil.in(.linen).squared, 1089)
        ])
        func baseValue(of value: Double, _ unit: Unit<Mock>, expected: Double) {
            let result = Mock.baseValue(of: value, unit)
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Defined by exponent * baseUnit's dimensionality", arguments: [
            (49, Gil.baseUnit.squared, 7),
            (225, Gil.in(.zeni).squared, 5),
            (1089, Gil.in(.linen).squared, 13)
        ])
        func convert(_ value: Double, to unit: Unit<Mock>, expected: Double) {
            let result = Mock.convert(value, to: unit)
            #expect(result == expected)
        }
    }
}

// MARK: Unit (EX)
extension UnitTests {
    typealias Mock = Unit<Gil>

    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 2nd power", arguments: [
        (Mock.gil, Unit<Square<Gil>>("g²", details: .init(.gil)))
    ])
    func squared(_ sut: Mock, expected: Unit<Square<Gil>>) {
        let result = sut.squared
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Creates a new unit from an Exponential", arguments: [
        (Gil.E<5>(.linen), Unit<Gil.E<5>>("ln^5", details: Gil.E<5>(.linen)))
    ])
    func initializer(e exponential: Gil.E<5>, expected: Unit<Gil.E<5>>) {
        let result = Unit(e: exponential)
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 2nd power", arguments: [
        (Mock.zeni, Unit<Square<Gil>>("z²", details: .init(.zeni)))
    ])
    func square(_ sut: Unit<Gil>, expected: Unit<Square<Gil>>) {
        let result = Unit.square(sut)
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Returns a dimension elevated to the 3nd power", arguments: [
        (Mock.gil, Unit<Cubic<Gil>>("g³", details: .init(.gil)))
    ])
    func cubic(_ sut: Unit<Gil>, expected: Unit<Cubic<Gil>>) {
        let result = Unit.cubic(sut)
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Transforms unit to the inferred power", arguments: [
        (Mock.gil, Unit<Gil.E<9>>(e: .init(.gil)))
    ])
    func pow(_ sut: Unit<Gil>, expected: Unit<Gil.E<9>>) {
        let result: Unit<Gil.E<9>> = sut.pow()
        #expect(result == expected)
    }

    @available(macOS 26.0, *)
    @Test("Transforms exponent 1 back into a normal unit", arguments: [
        (Unit<Linear<Gil>>(e: .init(.zeni)), Mock.zeni)
    ])
    func inlined(_ sut: Unit<Linear<Gil>>, expected: Unit<Gil>) {
        let result = sut.inlined()
        #expect(result == expected)
    }
}
