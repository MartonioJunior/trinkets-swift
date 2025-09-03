//
//  LinearConverter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/09/2025.
//

import Testing
@testable import TrinketsUnits

struct LinearConverterTests {
    @Test("Creates a new linear converter", arguments: [
        (1, 3),
        (5, 0),
        (-2, 1)
    ])
    func initializer(_ a: Double, k: Double) {
        let result = LinearConverter(a, k: k)
        #expect(result.coefficient == a)
        #expect(result.constant == k)
    }

    // MARK: Operators
    @Test("Multiplies converter by factor", arguments: [
        (LinearConverter(2, k: 3), 4, LinearConverter(8, k: 12)),
        (LinearConverter(2, k: 3), -2, LinearConverter(-4, k: -6)),
        (LinearConverter(6, k: 8), 0, LinearConverter(0)),
        (LinearConverter(6), 4, LinearConverter(24)),
        (LinearConverter(0, k: 5), 4, LinearConverter(0, k: 20))
    ])
    func multiply(lhs: LinearConverter, rhs: Double, expected: LinearConverter) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    @Test("Divides converter by factor", arguments: [
        (LinearConverter(20, k: 30), 4, LinearConverter(5, k: 7.5)),
        (LinearConverter(2, k: 3), -2, LinearConverter(-1, k: -1.5)),
        (LinearConverter(6, k: 8), 0, nil),
        (LinearConverter(6), 4, LinearConverter(1.5)),
        (LinearConverter(0, k: 5), 4, LinearConverter(0, k: 1.25))
    ])
    func divide(lhs: LinearConverter, rhs: Double, expected: LinearConverter?) {
        let result = lhs / rhs
        #expect(result == expected)
    }

    // MARK: DotSyntax
    @Test("Returns a base unit axis")
    func base() {
        let result = LinearConverter.base
        #expect(result.coefficient == 1)
        #expect(result.constant == 0)
    }

    @Test("Instances based on a linear function", arguments: [
        (3, 4, LinearConverter(3, k: 4))
    ])
    func linear(_ a: Double, k: Double, expected: LinearConverter) {
        let result: LinearConverter = .linear(a, k: k)
        #expect(result == expected)
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Requires lesser coefficient and constants lesser or equal", arguments: [
            (LinearConverter(2, k: 3), LinearConverter(4, k: 5), true),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 3), true),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 2), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 5), true),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 3), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 2), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 5), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 3), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 1), false)
        ])
        func lesserThan(lhs: LinearConverter, rhs: LinearConverter, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }

        @Test("Requires lesser or equal coefficients and constants", arguments: [
            (LinearConverter(2, k: 3), LinearConverter(4, k: 5), true),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 3), true),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 2), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 5), true),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 3), true),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 2), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 5), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 3), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 1), false)
        ])
        func lessOrEqual(lhs: LinearConverter, rhs: LinearConverter, expected: Bool) {
            let result = lhs <= rhs
            #expect(result == expected)
        }

        @Test("Requires greater or equal coefficients and constants", arguments: [
            (LinearConverter(2, k: 3), LinearConverter(4, k: 5), false),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 3), false),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 2), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 5), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 3), true),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 2), true),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 5), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 3), true),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 1), true)
        ])
        func greaterOrEqual(lhs: LinearConverter, rhs: LinearConverter, expected: Bool) {
            let result = lhs >= rhs
            #expect(result == expected)
        }

        @Test("Requires greater or equal coefficients and constants", arguments: [
            (LinearConverter(2, k: 3), LinearConverter(4, k: 5), false),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 3), false),
            (LinearConverter(2, k: 3), LinearConverter(4, k: 2), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 5), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 3), false),
            (LinearConverter(3, k: 3), LinearConverter(3, k: 2), true),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 5), false),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 3), true),
            (LinearConverter(3, k: 3), LinearConverter(2, k: 1), true)
        ])
        func greaterThan(lhs: LinearConverter, rhs: LinearConverter, expected: Bool) {
            let result: Bool = lhs > rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Converter
    struct ConformsToConverter {
        @Test("Returns result of linear function", arguments: [
            (LinearConverter(2, k: 3), 5, 13),
            (LinearConverter(2, k: 0), 5, 10),
            (LinearConverter(0, k: 3), 5, 3),
            (LinearConverter(2, k: -3), 5, 7),
            (LinearConverter(-3, k: 3), 5, -12),
            (LinearConverter(0, k: 0), 99, 0)
        ])
        func baseValue(_ sut: LinearConverter, of value: Double, expected: Double) {
            let result = sut.baseValue(of: value)
            #expect(result == expected)
        }

        @Test("Returns value of linear function with specified result", arguments: [
            (LinearConverter(2, k: 3), 5, 1),
            (LinearConverter(2, k: 0), 5, 2.5),
            (LinearConverter(0, k: 3), 5, nil),
            (LinearConverter(2, k: -3), 5, 4),
            (LinearConverter(-3, k: 3), 15, -4),
            (LinearConverter(0, k: 0), 99, nil)
        ])
        func convert(_ sut: LinearConverter, _ baseValue: Double, expected: Double?) {
            let result = sut.convert(baseValue)
            #expect(result == expected)
        }
    }
}
