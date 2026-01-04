//
//  Tally+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/12/2025.
//

@testable import Inventory
import Testing

struct TallyTests {
    @Test("Defines the quantity of a Tally", arguments: [
        (Tally.value(22), UInt(22)),
        (Tally.infinite, UInt.max),
        (Tally.nullify, UInt(0))
    ])
    func amount(_ sut: Tally, expected: UInt) {
        #expect(sut.amount == expected)
    }

    @Test("Defines if a Tally has stock available", arguments: [
        (Tally.value(22), true),
        (Tally.value(0), false),
        (Tally.infinite, true),
        (Tally.nullify, false)
    ])
    func inStock(_ sut: Tally, expected: Bool) {
        #expect(sut.inStock == expected)
    }

    // MARK: Operators
    @Test("Adds a value to the Tally", arguments: [
        (Tally.value(3), UInt(5), Tally.value(8)),
        (Tally.value(6), UInt(0), Tally.value(6)),
        (Tally.value(32), UInt.max, Tally.value(.max)),
        (Tally.infinite, UInt(5), Tally.infinite),
        (Tally.infinite, UInt(0), Tally.infinite),
        (Tally.infinite, UInt.max, Tally.infinite),
        (Tally.nullify, UInt(5), Tally.nullify),
        (Tally.nullify, UInt.max, Tally.nullify),
        (Tally.nullify, UInt(0), Tally.nullify)
    ])
    func plus(lhs: Tally, rhs: UInt, expected: Tally) {
        let resultA = lhs + rhs
        #expect(resultA == expected)

        var resultB = lhs
        resultB += rhs
        #expect(resultB == expected)
    }

    @Test("Subtracts a value to the Tally", arguments: [
        (Tally.value(32), UInt(19), Tally.value(13)),
        (Tally.value(3), UInt(5), Tally.value(0)),
        (Tally.value(6), UInt(0), Tally.value(6)),
        (Tally.infinite, UInt(5), Tally.infinite),
        (Tally.infinite, UInt(0), Tally.infinite),
        (Tally.infinite, UInt.max, Tally.infinite),
        (Tally.nullify, UInt(5), Tally.nullify),
        (Tally.nullify, UInt.max, Tally.nullify),
        (Tally.nullify, UInt(0), Tally.nullify)
    ])
    func minus(lhs: Tally, rhs: UInt, expected: Tally) {
        let resultA = lhs - rhs
        #expect(resultA == expected)

        var resultB = lhs
        resultB -= rhs
        #expect(resultB == expected)
    }

    @Test("Multiplies the Tally with a value", arguments: [
        (Tally.value(32), UInt(2), Tally.value(64)),
        (Tally.value(3), UInt.max, Tally.value(.max)),
        (Tally.value(99), UInt(0), Tally.value(0)),
        (Tally.infinite, UInt(5), Tally.infinite),
        (Tally.infinite, UInt(0), Tally.infinite),
        (Tally.infinite, UInt.max, Tally.infinite),
        (Tally.nullify, UInt(5), Tally.nullify),
        (Tally.nullify, UInt.max, Tally.nullify),
        (Tally.nullify, UInt(0), Tally.nullify)
    ])
    func timesValue(lhs: Tally, rhs: UInt, expected: Tally) {
        let resultA = lhs * rhs
        #expect(resultA == expected)

        var resultB = lhs
        resultB *= rhs
        #expect(resultB == expected)
    }

    @Test("Multiples tallies together (when possible)", arguments: [
        (Tally.value(22), Tally.value(4), Tally.value(88)),
        (Tally.value(22), Tally.value(.max), Tally.value(.max)),
        (Tally.value(22), Tally.value(0), Tally.value(0)),
        (Tally.value(22), Tally.infinite, Tally.infinite),
        (Tally.value(22), Tally.nullify, Tally.nullify),
        (Tally.infinite, Tally.value(4), Tally.infinite),
        (Tally.infinite, Tally.value(.max), Tally.infinite),
        (Tally.infinite, Tally.value(0), Tally.infinite),
        (Tally.infinite, Tally.infinite, Tally.infinite),
        (Tally.infinite, Tally.nullify, Tally?.none),
        (Tally.nullify, Tally.value(4), Tally.nullify),
        (Tally.nullify, Tally.value(.max), Tally.nullify),
        (Tally.nullify, Tally.value(0), Tally.nullify),
        (Tally.nullify, Tally.infinite, Tally?.none),
        (Tally.nullify, Tally.nullify, Tally.nullify)
    ])
    func times(lhs: Tally, rhs: Tally, expected: Tally?) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    @Test("Divides a Tally by the given value", arguments: [
        (Tally.value(32), UInt(2), Tally.value(16)),
        (Tally.value(3), UInt.max, Tally.value(0)),
        (Tally.value(99), UInt(0), Tally.value(0)),
        (Tally.infinite, UInt(5), Tally.infinite),
        (Tally.infinite, UInt(0), Tally.infinite),
        (Tally.infinite, UInt.max, Tally.infinite),
        (Tally.nullify, UInt(5), Tally.nullify),
        (Tally.nullify, UInt.max, Tally.nullify),
        (Tally.nullify, UInt(0), Tally.nullify)
    ])
    func divisionValue(lhs: Tally, rhs: UInt, expected: Tally) {
        let resultA = lhs / rhs
        #expect(resultA == expected)

        var resultB = lhs
        resultB /= rhs
        #expect(resultB == expected)
    }

    @Test("Divides a Tally by the other (when possible)", arguments: [
        (Tally.value(22), Tally.value(2), Tally.value(11)),
        (Tally.value(22), Tally.value(.max), Tally.value(0)),
        (Tally.value(22), Tally.value(0), Tally.value(0)),
        (Tally.value(22), Tally.infinite, Tally.value(0)),
        (Tally.value(22), Tally.nullify, Tally?.none),
        (Tally.infinite, Tally.value(4), Tally.infinite),
        (Tally.infinite, Tally.value(.max), Tally.infinite),
        (Tally.infinite, Tally.value(0), Tally.infinite),
        (Tally.infinite, Tally.infinite, Tally.value(1)),
        (Tally.infinite, Tally.nullify, Tally?.none),
        (Tally.nullify, Tally.value(4), Tally.nullify),
        (Tally.nullify, Tally.value(.max), Tally.nullify),
        (Tally.nullify, Tally.value(0), Tally.nullify),
        (Tally.nullify, Tally.infinite, Tally.nullify),
        (Tally.nullify, Tally.nullify, Tally.value(1))
    ])
    func division(lhs: Tally, rhs: Tally, expected: Tally?) {
        let result = lhs / rhs
        #expect(result == expected)
    }

    @Test("Defines a Tally with amount 1")
    func one() {
        #expect(Tally.one == Tally.value(1))
    }

    // MARK: Self: AdditiveArithmetic
    struct ConformsToAdditiveArithmetic {
        @Test("Defines the Tally with amount 0")
        func zero() {
            #expect(Tally.zero == Tally.value(0))
        }

        @Test("Adds tallies together", arguments: [
            (Tally.value(22), Tally.value(4), Tally.value(26)),
            (Tally.value(22), Tally.value(.max), Tally.value(.max)),
            (Tally.value(22), Tally.value(0), Tally.value(22)),
            (Tally.value(22), Tally.infinite, Tally.infinite),
            (Tally.value(22), Tally.nullify, Tally.nullify),
            (Tally.infinite, Tally.value(4), Tally.infinite),
            (Tally.infinite, Tally.value(.max), Tally.infinite),
            (Tally.infinite, Tally.value(0), Tally.infinite),
            (Tally.infinite, Tally.infinite, Tally.infinite),
            (Tally.infinite, Tally.nullify, Tally.infinite),
            (Tally.nullify, Tally.value(4), Tally.nullify),
            (Tally.nullify, Tally.value(.max), Tally.nullify),
            (Tally.nullify, Tally.value(0), Tally.nullify),
            (Tally.nullify, Tally.infinite, Tally.infinite),
            (Tally.nullify, Tally.nullify, Tally.nullify)
        ])
        func plus(lhs: Tally, rhs: Tally, expected: Tally) {
            let result = lhs + rhs
            #expect(result == expected)
        }

        @Test("Subtracts one Tally from another", arguments: [
            (Tally.value(22), Tally.value(4), Tally.value(18)),
            (Tally.value(22), Tally.value(.max), Tally.value(0)),
            (Tally.value(22), Tally.value(0), Tally.value(22)),
            (Tally.value(22), Tally.infinite, Tally.nullify),
            (Tally.value(22), Tally.nullify, Tally.value(22)),
            (Tally.infinite, Tally.value(4), Tally.infinite),
            (Tally.infinite, Tally.value(.max), Tally.infinite),
            (Tally.infinite, Tally.value(0), Tally.infinite),
            (Tally.infinite, Tally.infinite, Tally.value(0)),
            (Tally.infinite, Tally.nullify, Tally.infinite),
            (Tally.nullify, Tally.value(4), Tally.nullify),
            (Tally.nullify, Tally.value(.max), Tally.nullify),
            (Tally.nullify, Tally.value(0), Tally.nullify),
            (Tally.nullify, Tally.infinite, Tally.nullify),
            (Tally.nullify, Tally.nullify, Tally.nullify)
        ])
        func minus(lhs: Tally, rhs: Tally, expected: Tally) {
            let result = lhs - rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Compares two tallies", arguments: [
            (Tally.value(7), Tally.value(7), false),
            (Tally.value(12), Tally.value(4), false),
            (Tally.value(4), Tally.value(12), true),
            (Tally.value(0), Tally.nullify, false),
            (Tally.nullify, Tally.value(0), true),
            (Tally.nullify, Tally.nullify, false),
            (Tally.value(.max), Tally.infinite, true),
            (Tally.infinite, Tally.value(.max), false),
            (Tally.infinite, Tally.infinite, false)
        ])
        func lessThan(lhs: Tally, rhs: Tally, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        @Test("Creates a new Tally with fixed amount", arguments: [
            (UInt(23), Tally.value(23))
        ])
        func initializer(integerLiteral value: UInt, expected: Tally) {
            let result = Tally(integerLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByILiteral
    struct ConformsToExpressibleByILiteral {
        @Test("Creates a nullify tally")
        func initializer() {
            let result = Tally(nilLiteral: ())
            #expect(result == Tally.nullify)
        }
    }
}
