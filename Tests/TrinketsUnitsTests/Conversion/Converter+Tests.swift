//
//  Converter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

import Testing
@testable import TrinketsUnits

struct ConverterTests {
    // MARK: Mock
    struct Mock: Converter {
        typealias Value = Double

        func baseValue(of value: Double) -> Double { value }
    }

    // MARK: Default Implementation
    @Test("Always returns nil by default", arguments: [
        (0, Optional<Mock.Value>.none),
        (-22, Optional<Mock.Value>.none),
        (78, Optional<Mock.Value>.none)
    ])
    func convert(_ baseValue: Mock.Value, expected: Mock.Value?) {
        let result = Mock().convert(baseValue)
        #expect(result == expected)
    }
}

// MARK: Dimension (EX)
extension DimensionTests {
    struct FeaturesIsConverterAndValueIsDouble {
        @Test("Uses converter to define base value", arguments: [
            (Mock.Value(25), Mock.baseUnit, LinearConverter(1)),
            (Mock.Value(15), Mock.Unit.zeni, LinearConverter(3)),
            (Mock.Value(9), Mock.Unit.linen, LinearConverter(2, k: 7)),
            (Mock.Value(15), Mock.Unit.constant(1), LinearConverter(0, k: 1)),
            (Mock.Value(15), Mock.Unit.constant(0), LinearConverter(0))
        ])
        func baseValue(of value: Mock.Value, _ unit: Mock.Unit, converter: LinearConverter) {
            let result = Gil.baseValue(of: value, unit)
            let expected = converter.baseValue(of: value)
            #expect(result == expected)
        }

        @Test("Uses converter to define value", arguments: [
            (Mock.Value(25), Mock.baseUnit, LinearConverter(1)),
            (Mock.Value(15), Mock.Unit.zeni, LinearConverter(3)),
            (Mock.Value(9), Mock.Unit.linen, LinearConverter(2, k: 7)),
            (Mock.Value(15), Mock.Unit.constant(1), LinearConverter(0, k: 1)),
            (Mock.Value(15), Mock.Unit.constant(0), LinearConverter(0))
        ])
        func convert(_ baseValue: Mock.Value, to unit: Mock.Unit, converter: LinearConverter) {
            let result = Gil.convert(baseValue, to: unit)
            let expected = converter.convert(baseValue)

            if let expected {
                #expect(result == expected)
            } else {
                #expect(result.isNaN)
            }
        }
    }
}
