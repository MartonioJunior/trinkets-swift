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
        (Tally.fixed(22), UInt(22)),
        (Tally.infinite, UInt.max),
        (Tally.nullify, UInt(0))
    ])
    func amount(_ sut: Tally, expected: UInt) {
        #expect(sut.amount == expected)
    }

    @Test("Defines if a Tally has stock available", arguments: [
        (Tally.fixed(22), true),
        (Tally.fixed(0), false),
        (Tally.infinite, true),
        (Tally.nullify, false)
    ])
    func inStock(_ sut: Tally, expected: Bool) {
        #expect(sut.inStock == expected)
    }

    // MARK: Operators
    @Test("Adds a value to the Tally", arguments: [
        (Tally.fixed(3), UInt(5), Tally.fixed(8)),
        (Tally.fixed(6), UInt(0), Tally.fixed(6)),
        (Tally.fixed(32), UInt.max, Tally.fixed(.max)),
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
        (Tally.fixed(32), UInt(19), Tally.fixed(13)),
        (Tally.fixed(3), UInt(5), Tally.fixed(0)),
        (Tally.fixed(6), UInt(0), Tally.fixed(6)),
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
        (Tally.fixed(32), UInt(2), Tally.fixed(64)),
        (Tally.fixed(3), UInt.max, Tally.fixed(.max)),
        (Tally.fixed(99), UInt(0), Tally.fixed(0)),
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
        (Tally.fixed(22), Tally.fixed(4), Tally.fixed(88)),
        (Tally.fixed(22), Tally.fixed(.max), Tally.fixed(.max)),
        (Tally.fixed(22), Tally.fixed(0), Tally.fixed(0)),
        (Tally.fixed(22), Tally.infinite, Tally.infinite),
        (Tally.fixed(22), Tally.nullify, Tally.nullify),
        (Tally.infinite, Tally.fixed(4), Tally.infinite),
        (Tally.infinite, Tally.fixed(.max), Tally.infinite),
        (Tally.infinite, Tally.fixed(0), Tally.infinite),
        (Tally.infinite, Tally.infinite, Tally.infinite),
        (Tally.infinite, Tally.nullify, Tally?.none),
        (Tally.nullify, Tally.fixed(4), Tally.nullify),
        (Tally.nullify, Tally.fixed(.max), Tally.nullify),
        (Tally.nullify, Tally.fixed(0), Tally.nullify),
        (Tally.nullify, Tally.infinite, Tally?.none),
        (Tally.nullify, Tally.nullify, Tally.nullify)
    ])
    func times(lhs: Tally, rhs: Tally, expected: Tally?) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    @Test("Divides a Tally by the given value", arguments: [
        (Tally.fixed(32), UInt(2), Tally.fixed(16)),
        (Tally.fixed(3), UInt.max, Tally.fixed(0)),
        (Tally.fixed(99), UInt(0), Tally.fixed(0)),
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
        (Tally.fixed(22), Tally.fixed(2), Tally.fixed(11)),
        (Tally.fixed(22), Tally.fixed(.max), Tally.fixed(0)),
        (Tally.fixed(22), Tally.fixed(0), Tally.fixed(0)),
        (Tally.fixed(22), Tally.infinite, Tally.fixed(0)),
        (Tally.fixed(22), Tally.nullify, Tally?.none),
        (Tally.infinite, Tally.fixed(4), Tally.infinite),
        (Tally.infinite, Tally.fixed(.max), Tally.infinite),
        (Tally.infinite, Tally.fixed(0), Tally.infinite),
        (Tally.infinite, Tally.infinite, Tally.fixed(1)),
        (Tally.infinite, Tally.nullify, Tally?.none),
        (Tally.nullify, Tally.fixed(4), Tally.nullify),
        (Tally.nullify, Tally.fixed(.max), Tally.nullify),
        (Tally.nullify, Tally.fixed(0), Tally.nullify),
        (Tally.nullify, Tally.infinite, Tally.nullify),
        (Tally.nullify, Tally.nullify, Tally.fixed(1))
    ])
    func division(lhs: Tally, rhs: Tally, expected: Tally?) {
        let result = lhs / rhs
        #expect(result == expected)
    }

    @Test("Defines a Tally with amount 1")
    func one() {
        #expect(Tally.one == Tally.fixed(1))
    }

    // MARK: Self: AdditiveArithmetic
    struct ConformsToAdditiveArithmetic {
        @Test("Defines the Tally with amount 0")
        func zero() {
            #expect(Tally.zero == Tally.fixed(0))
        }

        @Test("Adds tallies together", arguments: [
            (Tally.fixed(22), Tally.fixed(4), Tally.fixed(26)),
            (Tally.fixed(22), Tally.fixed(.max), Tally.fixed(.max)),
            (Tally.fixed(22), Tally.fixed(0), Tally.fixed(22)),
            (Tally.fixed(22), Tally.infinite, Tally.infinite),
            (Tally.fixed(22), Tally.nullify, Tally.nullify),
            (Tally.infinite, Tally.fixed(4), Tally.infinite),
            (Tally.infinite, Tally.fixed(.max), Tally.infinite),
            (Tally.infinite, Tally.fixed(0), Tally.infinite),
            (Tally.infinite, Tally.infinite, Tally.infinite),
            (Tally.infinite, Tally.nullify, Tally.infinite),
            (Tally.nullify, Tally.fixed(4), Tally.nullify),
            (Tally.nullify, Tally.fixed(.max), Tally.nullify),
            (Tally.nullify, Tally.fixed(0), Tally.nullify),
            (Tally.nullify, Tally.infinite, Tally.infinite),
            (Tally.nullify, Tally.nullify, Tally.nullify)
        ])
        func plus(lhs: Tally, rhs: Tally, expected: Tally) {
            let result = lhs + rhs
            #expect(result == expected)
        }

        @Test("Subtracts one Tally from another", arguments: [
            (Tally.fixed(22), Tally.fixed(4), Tally.fixed(18)),
            (Tally.fixed(22), Tally.fixed(.max), Tally.fixed(0)),
            (Tally.fixed(22), Tally.fixed(0), Tally.fixed(22)),
            (Tally.fixed(22), Tally.infinite, Tally.nullify),
            (Tally.fixed(22), Tally.nullify, Tally.fixed(22)),
            (Tally.infinite, Tally.fixed(4), Tally.infinite),
            (Tally.infinite, Tally.fixed(.max), Tally.infinite),
            (Tally.infinite, Tally.fixed(0), Tally.infinite),
            (Tally.infinite, Tally.infinite, Tally.fixed(0)),
            (Tally.infinite, Tally.nullify, Tally.infinite),
            (Tally.nullify, Tally.fixed(4), Tally.nullify),
            (Tally.nullify, Tally.fixed(.max), Tally.nullify),
            (Tally.nullify, Tally.fixed(0), Tally.nullify),
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
            (Tally.fixed(7), Tally.fixed(7), false),
            (Tally.fixed(12), Tally.fixed(4), false),
            (Tally.fixed(4), Tally.fixed(12), true),
            (Tally.fixed(0), Tally.nullify, false),
            (Tally.nullify, Tally.fixed(0), true),
            (Tally.nullify, Tally.nullify, false),
            (Tally.fixed(.max), Tally.infinite, true),
            (Tally.infinite, Tally.fixed(.max), false),
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
            (UInt(23), Tally.fixed(23))
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
