//
//  Formattable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/02/2026.
//

import Foundation
import Testing
@testable import TrinketsUnits

private struct FormattableTests {
    struct MockUnitFormatStyle: FormatStyle {
        func format(_ value: RPGMoney.Constant) -> String {
            value.description
        }
    }

    @Test("Allows outputting the type into a new format", arguments: [
        (RPGMoney.Constant(value: 5), MockUnitFormatStyle(), "5$")
    ])
    func formatted(_ sut: RPGMoney.Constant, _ format: MockUnitFormatStyle, expected: String) {
        let result = sut.formatted(format)
        #expect(result == expected)
    }
}
