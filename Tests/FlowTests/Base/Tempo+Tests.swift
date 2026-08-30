//
//  Tempo+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/07/2026.
//

@testable import Flow
import Foundation
import Testing

struct TempoTests {
    @Test("Creates a tempo from a multiplier", arguments: [
        (12)
    ])
    func initializer_multiplier(_ multiplier: Int) {
        let result = Tempo(multiplier)
        #expect(result.multiplier == multiplier)
    }

    // MARK: Operators
    @Test("Multiplies value by tempo", arguments: [
        (3, Tempo<Int>(2), 6)
    ])
    func multiplier(lhs: Int, rhs: Tempo<Int>, expected: Int) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    @Test("Multiplies tempo by value", arguments: [
        (Tempo<Int>(3), 2, Tempo<Int>(6))
    ])
    func multiplier(lhs: Tempo<Int>, rhs: Int, expected: Tempo<Int>) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    @Test("Multiplies tempos together", arguments: [
        (Tempo<Int>(3), Tempo<Int>(2), Tempo<Int>(6))
    ])
    func multiplier(lhs: Tempo<Int>, rhs: Tempo<Int>, expected: Tempo<Int>) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    // MARK: DotSyntax
    @Test("Constants for the type", arguments: [
        (Tempo<Int>.forward, Tempo<Int>(1)),
        (Tempo<Int>.halt, Tempo<Int>(0)),
        (Tempo<Int>.reverse, Tempo<Int>(-1)),
        (Tempo<Int>.rewind, Tempo<Int>(-2))
    ])
    func constants(_ sut: Tempo<Int>, expected: Tempo<Int>) {
        #expect(sut == expected)
    }

    @Test("Creates a fast tempo", arguments: [
        (UInt(4), Tempo<UInt>(4)),
        (UInt(7), Tempo<UInt>(7)),
        (UInt(0), Tempo<UInt>(1))
    ])
    func fastForward(x multiplier: UInt, expected: Tempo<UInt>) {
        let result = Tempo.fastForward(x: multiplier)
        #expect(result == expected)
    }

    // MARK: Self: AdditiveArithmetic
    struct ConformsToAdditiveArithmetic {
        @Test("Adds two tempos together", arguments: [
            (Tempo<Int>(3), Tempo<Int>(4), Tempo<Int>(7)),
            (Tempo<Int>(3), Tempo<Int>(0), Tempo<Int>(3)),
            (Tempo<Int>(0), Tempo<Int>(4), Tempo<Int>(4))
        ])
        func plus(lhs: Tempo<Int>, rhs: Tempo<Int>, expected: Tempo<Int>) {
            let result = lhs + rhs
            #expect(result == expected)
        }

        @Test("Adds two tempos together", arguments: [
            (Tempo<Int>(7), Tempo<Int>(4), Tempo<Int>(3)),
            (Tempo<Int>(3), Tempo<Int>(4), Tempo<Int>(-1)),
            (Tempo<Int>(3), Tempo<Int>(0), Tempo<Int>(3)),
            (Tempo<Int>(0), Tempo<Int>(4), Tempo<Int>(-4))
        ])
        func minus(lhs: Tempo<Int>, rhs: Tempo<Int>, expected: Tempo<Int>) {
            let result = lhs - rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Compares two tempos", arguments: [
            (Tempo<Int>(7), Tempo<Int>(4), false),
            (Tempo<Int>(3), Tempo<Int>(4), true),
            (Tempo<Int>(3), Tempo<Int>(3), false)
        ])
        func lesserThan(lhs: Tempo<Int>, rhs: Tempo<Int>, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        @Test("Creates from an integer value", arguments: [
            (12, Tempo<Int>(12))
        ])
        func initializer(integerLiteral value: Int, expected: Tempo<Int>) {
            let result = Tempo<Int>(integerLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByFloatLiteral
    struct ConformsToExpressibleByFloatLiteral {
        @Test("Creates from an float value", arguments: [
            (12.0, Tempo<Double>(12))
        ])
        func initializer(integerLiteral value: Double, expected: Tempo<Double>) {
            let result = Tempo<Double>(floatLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self.Value: FloatingPoint
    struct ValueConformsToFloatingPoint {
        @Test("Divides tempo by a factor", arguments: [
            (Tempo<Double>(22), 2, Tempo<Double>(11)),
            (Tempo<Double>(13), 4, Tempo<Double>(3.25))
        ])
        func divide(lhs: Tempo<Double>, rhs: Double, expected: Tempo<Double>) {
            let result = lhs / rhs
            #expect(result == expected)
        }

        @Test("Creates tempo with slowdown", arguments: [
            (SortOrder.forward, 4, Tempo<Double>(0.25)),
            (SortOrder.reverse, 2, Tempo<Double>(-0.5)),
            (SortOrder.forward, 1, Tempo<Double>(1)),
            (SortOrder.reverse, 1, Tempo<Double>(-1))
        ])
        func slow(_ sortOrder: SortOrder, by factor: Double, expected: Tempo<Double>) {
            let result = Tempo.slow(sortOrder, by: factor)
            #expect(result == expected)
        }
    }

    // MARK: Self.Value: SignedNumeric
    struct ValueConformsToSignedNumeric {
        @Test("Creates a tempo from a sort order", arguments: [
            (SortOrder.forward, 1),
            (SortOrder.reverse, -1)
        ])
        func initializer_sortOrder(_ sortOrder: SortOrder, expected: Int) {
            let result = Tempo<Int>(sortOrder)
            #expect(result.multiplier == expected)
        }

        @Test("Creates a fast tempo", arguments: [
            (SortOrder.forward, 4, Tempo<Int>(4)),
            (SortOrder.reverse, 7, Tempo<Int>(-7)),
            (SortOrder.forward, 0, Tempo<Int>(1)),
            (SortOrder.reverse, 0, Tempo<Int>(-1))
        ])
        func fast(_ sortOrder: SortOrder, x multiplier: Int, expected: Tempo<Int>) {
            let result = Tempo.fast(sortOrder, x: multiplier)
            #expect(result == expected)
        }

        @Test("Creates a reverse pace", arguments: [
            (4, Tempo<Int>(-4)),
            (-3, Tempo<Int>(-1)),
            (0, Tempo<Int>(-1))
        ])
        func rewind(x multiplier: Int, expected: Tempo<Int>) {
            let result = Tempo.rewind(x: multiplier)
            #expect(result == expected)
        }
    }

    // MARK: Sequence (EX)

    // MARK: Strideable (EX)
    struct StrideableTests {
        @Test("Advances by amount paced by tempo", arguments: [
            (4, 3, Tempo<Int>(2), 10),
            (4, 3, Tempo<Int>(0), 4),
            (4, 0, Tempo<Int>(2), 4)
        ])
        func advanced(_ sut: Int, by n: Int, in tempo: Tempo<Int>, expected: Int) {
            let result = sut.advanced(by: n, in: tempo)
            #expect(result == expected)
        }

        @Test("Offsets value in the reverse pace", arguments: [
            (4, 3, 1),
            (4, 0, 4)
        ])
        func backtracked(_ sut: Int, by n: UInt, expected: Int) {
            let result = sut.backtracked(by: n)
            #expect(result == expected)
        }
    }
}
