//
//  Formattable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/02/2026.
//

import Foundation
import Testing
@testable import TrinketsUnits

struct FormattableTests {
    struct MockUnitFormatStyle: FormatStyle {
        func format(_ value: Gil.Unit) -> String {
            value.symbol
        }
    }

    struct MockMeasurementFormatStyle: FormatStyle {
        func format(_ value: Gil.Measure) -> String {
            "\(value.value)" + value.unit.formatted(MockUnitFormatStyle())
        }
    }

    @Test("Allows outputting the type into a new format", arguments: [
        (Gil.Unit.linen, MockUnitFormatStyle(), "ln")
    ])
    func formatted(_ sut: Gil.Unit, _ format: MockUnitFormatStyle, expected: String) {
        let result = sut.formatted(format)
        #expect(result == expected)
    }

    @Test("Allows outputting the type into a new format", arguments: [
        (Gil.of(30, .zeni), MockMeasurementFormatStyle(), "30z")
    ])
    func formatted(_ sut: Gil.Measure, _ format: MockMeasurementFormatStyle, expected: String) {
        let result = sut.formatted(format)
        #expect(result == expected)
    }
}
