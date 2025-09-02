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

        ])
