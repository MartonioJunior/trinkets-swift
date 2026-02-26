//
//  Transaction+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/02/26.
//

@testable import Exchanges
import Testing

// MARK: Mocks
func mockTransaction(_ contents: Int) -> Transaction<Int, Int> {
    .init(contents) {
        $0 += $1
        return nil
    }
}

struct TransactionTests {
    // MARK: Initializers
    @Test("Creates a new transaction")
    func initializer() {
        var target = 0
        let transaction = Transaction("Banana", apply: countLetterA)
        let remainder = transaction.apply(to: &target)
        #expect(target == 3)
        #expect(remainder == nil)

        @Sendable
        func countLetterA(_ counter: inout Int, in text: String) -> String? {
            counter += text.count { $0 == "a" }
            return nil
        }
    }

    // MARK: Methods
    @Test("Creates a new transaction based on transforming contents", arguments: [
        (mockTransaction(2), mockTransaction(6))
    ])
    func map(_ sut: Transaction<Int, Int>, expected: Transaction<Int, Int>) {
        let result = sut.map(triple)
        #expect(result == expected)

        func triple(_ value: Int) -> Int {
            value * 3
        }
    }

    // MARK: DotSyntax
    @Test("Creates a transaction that does nothing and returns back the contents", arguments: [
        (6, Transaction<Int, Int>(6, apply: { _, contents in contents}))
    ])
    func noop(_ contents: Int, expected: Transaction<Int, Int>) {
        let result = Transaction<Int, Int>.noop(contents)
        var target = 0
        let remainder = result.apply(to: &target)

        #expect(result == expected)
        #expect(target == 0)
        #expect(remainder == contents)
    }

    @Test("Creates a transaction that does nothing and returns nothing", arguments: [
        (6, Transaction<Int, Int>(6, apply: { _, _ in nil }))
    ])
    func nullify(_ contents: Int, expected: Transaction<Int, Int>) {
        let result = Transaction<Int, Int>.nullify(contents)
        var target = 0
        let remainder = result.apply(to: &target)

        #expect(result == expected)
        #expect(target == 0)
        #expect(remainder == nil)
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        typealias Mock = Transaction<Int, Int>

        @Test("Checks whether a transaction is greater than another", arguments: [
            (mockTransaction(7), mockTransaction(9), true),
            (mockTransaction(7), mockTransaction(3), false),
            (mockTransaction(7), mockTransaction(7), false)
        ])
        func lesserThan(lhs: Mock, rhs: Mock, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Equatable
    struct ConformsToEquatable {
        typealias Mock = Transaction<Int, Int>

        @Test("Checks whether a transaction is greater than another", arguments: [
            (mockTransaction(7), mockTransaction(7), true),
            (mockTransaction(9), mockTransaction(3), false)
        ])
        func equals(lhs: Mock, rhs: Mock, expected: Bool) {
            let result = lhs == rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Modifier
    struct ConformsToModifier {
        @Test("Transforms the target based on the function", arguments: [
            (mockTransaction(3), 6, (remainder: Int?.none, target: 9))
        ])
        func apply(_ sut: Transaction<Int, Int>, to target: Int, expected: (remainder: Int?, target: Int)) {
            var target = target
            let remainder = sut.apply(to: &target)
            #expect(target == expected.target)
            #expect(remainder == expected.remainder)
        }
    }
}
