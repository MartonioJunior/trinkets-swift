//
//  Cooldown+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

@testable import Flow
import Testing

struct CooldownTests {
    @Test("Creates a new cooldown", arguments: [
        (1)
    ])
    func initializer(_ value: Int) {
        let result = Cooldown(value)
        #expect(result.value == value)
    }

    // MARK: Operators
    @Test("Calculates recovery instant", arguments: [
        (12, 4, 16),
        (13, 0, 13),
        (14, -5, 9)
    ])
    func plus(lhs: Int, rhs: Cooldown<Int>, expected: Int) {
        let result = lhs + rhs
        #expect(result == expected)
    }
}

extension CooldownTests {
    // MARK: Self: AdditiveArithmetic
    struct ConformsToAdditiveArithmetic {
        @Test("Constant for zero")
        func zero() {
            #expect(Cooldown<Int>.zero == Cooldown<Int>(.zero))
        }

        @Test("Adds two cooldown intervals", arguments: [
            (Cooldown<Int>(12), Cooldown<Int>(20), Cooldown<Int>(32))
        ])
        func plus(lhs: Cooldown<Int>, rhs: Cooldown<Int>, expected: Cooldown<Int>) {
            let result = lhs + rhs
            #expect(result == expected)
        }

        @Test("Adds two cooldown intervals", arguments: [
            (Cooldown<Int>(32), Cooldown<Int>(10), Cooldown<Int>(22))
        ])
        func minus(lhs: Cooldown<Int>, rhs: Cooldown<Int>, expected: Cooldown<Int>) {
            let result = lhs - rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Compares two cooldown intervals", arguments: [
            (Cooldown<Int>(12), Cooldown<Int>(20), true),
            (Cooldown<Int>(33), Cooldown<Int>(20), false),
            (Cooldown<Int>(20), Cooldown<Int>(20), false)
        ])
        func lesserThan(lhs: Cooldown<Int>, rhs: Cooldown<Int>, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByFloatLiteral
    struct ConformsToExpressibleByFloatLiteral {
        @Test("Creates cooldown from float", arguments: [
            (23.0, Cooldown<Double>(23.0))
        ])
        func initializer(integerLiteral value: Double, expected: Cooldown<Double>) {
            let result = Cooldown<Double>(floatLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        @Test("Creates cooldown from integer", arguments: [
            (23, Cooldown<Int>(23))
        ])
        func initializer(integerLiteral value: Int, expected: Cooldown<Int>) {
            let result = Cooldown<Int>(integerLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self.Interval: Numeric
    struct ConformsToNumeric {
        @Test("Multiplies cooldown by tempo", arguments: [
            (Cooldown<Int>(14), Tempo<Int>(2), Cooldown<Int>(28)),
            (Cooldown<Int>(14), Tempo<Int>(0), Cooldown<Int>(0)),
            (Cooldown<Int>(0), Tempo<Int>(2), Cooldown<Int>(0))
        ])
        func times(lhs: Cooldown<Int>, rhs: Tempo<Int>, expected: Cooldown<Int>) {
            let result = lhs * rhs
            #expect(result == expected)
        }
    }

    // MARK: Strideable (EX)
    struct StrideableTests {
        @Test("Calculates recovery instant", arguments: [
            (12, Cooldown<Int>(4), 16),
            (13, Cooldown<Int>(0), 13),
            (14, Cooldown<Int>(-5), 9)
        ])
        func recovery(_ sut: Int, after cooldown: Cooldown<Int>, expected: Int) {
            let result = sut.recovery(after: cooldown)
            #expect(result == expected)
        }
    }
}
