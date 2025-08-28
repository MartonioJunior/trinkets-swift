//
//  Unit+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/06/2025.
//

import Testing
@testable import TrinketsUnits

struct UnitTests {
    @Test("Creates a new instance with symbol and features", arguments: [
        ("o", LinearConverter(8))
    ])
    func initializer(_ symbol: Gil.Symbol, features: Gil.Features) {
        let unit = Unit<Gil>(symbol, details: features)
        #expect(unit.symbol == symbol)
        #expect(unit.features == features)
    }
    // MARK: Self: Comparable
    struct Comparable {
        @Test("Compares two features against each other", arguments: [
            (Gil.baseUnit, Gil.in(.linen), true),
            (Gil.in(.linen), Gil.baseUnit, false),
            (Gil.baseUnit, Gil.in(.zeni), true),
            (Gil.in(.zeni), Gil.baseUnit, false),
            (Gil.in(.linen), Gil.in(.zeni), false),
            (Gil.in(.zeni), Gil.in(.linen), false)
        ])
        func lesserThan(lhs: Unit<Gil>, rhs: Unit<Gil>, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: CustomStringConvertible
    struct CustomStringConvertible {
        @Test("Returns the description for unit", arguments: [
            (Unit.gil, "g"),
            (Unit.zeni, "z"),
            (Unit.linen, "ln")
        ])
        func description(sut: Unit<Gil>, expected: String) throws {
            #expect(sut.description == expected)
        }
    }

    // MARK: D: Dimension
    struct DConformsToDimension {
        @Test("Creates new measurement by combining unit with value", arguments: [
            (Gil.in(.zeni) * 80, Measurement<Gil, Double>(value: 80, unit: .zeni)),
            (80 * Gil.in(.zeni), Measurement<Gil, Double>(value: 80, unit: .zeni)),
            (Gil.in(.zeni).x(80), Measurement<Gil, Double>(value: 80, unit: .zeni)),
        ])
        func multiply(_ sut: Gil.Measure, expected: Gil.Measure) {
            #expect(sut == expected)
        }
    }

    // MARK: D.Features: Void
    struct DFeaturesIsVoid {
        @Test("Instances new symbol-only Units", arguments: [
            ("cloth", Unit<Material>("cloth"))
        ])
        func initializer(_ symbol: Material.Symbol, expected: Unit<Material>) {
            let result = Unit<Material>(symbol)
            #expect(result.symbol == expected.symbol)
            #expect(result.features == ())
        }
    }
}
