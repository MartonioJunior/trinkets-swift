//
//  Exchange+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/03/2026.
//

@testable import Exchanges
import Testing

// MARK: Mocks
func mockDrain(_ contents: Int) -> Transaction<Int?, Int> {
    .init(contents) {
        guard let value = $0 else { return $1 }

        $0 = value - $1
        return nil
    }
}

func mockExchange(_ drain: Int, for tap: Int) -> Exchange<Int, Int, Int> {
    .init(drain: .init(drain) {
        guard let value = $0 else { return $1 }
        $0 = value - $1
        return nil
    }, tap: .init(tap) {
        $0 += $1
        return nil
    })
}

struct ExchangeTests {
    // MARK: Initializers
    @Test("Creates a new exchange", arguments: [
        (Transaction<Int?, Int>.noop(8), Transaction<Int, Int>.noop(4))
    ])
    func initializer(drain: Transaction<Int?, Int>, tap: Transaction<Int, Int>) {
        let result = Exchange(drain: drain, tap: tap)
        #expect(result.drain == drain)
        #expect(result.tap == tap)
    }

    // MARK: Methods
    @Test("Removes resources from a target", arguments: [
        (mockExchange(3, for: 7), 8, (remainder: Int?.none, target: 5)),
        (Exchange<Int, Int, Int>(drain: .nullify(3), tap: mockTransaction(7)), 8, (remainder: Int?.none, target: 8))
    ])
    func drain(_ sut: Exchange<Int, Int, Int>, target: Int, expected: (remainder: Int?, target: Int)) {
        var targetOptional: Int? = target
        var targetNonOptional = target
        let remainderOptional = sut.drain(&targetOptional)
        let remainderNonOptional = sut.drain(unwrapped: &targetNonOptional)

        #expect(targetOptional == expected.target)
        #expect(targetNonOptional == expected.target)
        #expect(remainderOptional == expected.remainder)
        #expect(remainderNonOptional == expected.remainder)
    }

    @Test("Transforms both the purchase and sale contents", arguments: [
        (mockExchange(3, for: 5), mockExchange(9, for: 15))
    ])
    func map(_ sut: Exchange<Int, Int, Int>, expected: Exchange<Int, Int, Int>) {
        let result = sut.map(triple, for: triple)
        #expect(result == expected)

        func triple(_ value: Int) -> Int {
            value * 3
        }
    }

    @Test("Adds resources to a target", arguments: [
        (mockExchange(3, for: 5), 8, (remainder: Int?.none, target: 13))
    ])
    func tap(_ sut: Exchange<Int, Int, Int>, target: Int, expected: (remainder: Int?, target: Int)) {
        var target = target
        let remainder = sut.tap(&target)

        #expect(target == expected.target)
        #expect(remainder == expected.remainder)
    }

    @Test("Creates an exchange with simpler syntax", arguments: [
        (mockTransaction(6), mockDrain(12), mockExchange(12, for: 6))
    ])
    func buy(_ purchase: Transaction<Int, Int>, for price: Transaction<Int?, Int>, expected: Exchange<Int, Int, Int>) {
        let result = Exchange.buy {
            purchase
        } for: {
            price
        }
        #expect(result == expected)
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        typealias Mock = Exchange<Int, Int, Int>
        @Test("Compares the tap and drain, in that order", arguments: [
            (mockExchange(7, for: 8), mockExchange(9, for: 12), true),
            (mockExchange(7, for: 8), mockExchange(9, for: 6), true),
            (mockExchange(7, for: 8), mockExchange(7, for: 12), true),
            (mockExchange(7, for: 8), mockExchange(7, for: 8), false),
            (mockExchange(7, for: 8), mockExchange(4, for: 12), false),
            (mockExchange(7, for: 8), mockExchange(7, for: 2), false),
            (mockExchange(7, for: 8), mockExchange(4, for: 7), false)
        ])
        func lesserThan(lhs: Mock, rhs: Mock, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Equatable
    struct ConformsToEquatable {
        typealias Mock = Exchange<Int, Int, Int>

        @Test("Compares the tap and drain, in that order", arguments: [
            (mockExchange(7, for: 8), mockExchange(7, for: 8), true),
            (mockExchange(7, for: 8), mockExchange(7, for: 12), false),
            (mockExchange(7, for: 8), mockExchange(4, for: 8), false),
            (mockExchange(7, for: 8), mockExchange(4, for: 7), false)
        ])
        func equals(lhs: Mock, rhs: Mock, expected: Bool) {
            let result = lhs == rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Modifier
    struct ConformsToModifier {
        typealias Remainder = Exchange<Int, Int, Int>.Remainder
        @Test("Applies both tap and drain to a target", arguments: [
            (mockExchange(4, for: 9), 15, (remainder: Remainder?.none, result: 20)),
            (Exchange<Int, Int, Int>(drain: .noop(4), tap: mockTransaction(9)), 15, (remainder: Remainder(buy: 9, sell: 4), result: 15)),
            (Exchange<Int, Int, Int>(drain: mockDrain(4), tap: .noop(9)), 15, (remainder: Remainder(buy: 9), result: 11))
        ])
        func apply(_ sut: Exchange<Int, Int, Int>, target: Int, expected: (remainder: Remainder?, target: Int)) {
            var target = target
            let remainder = sut.apply(to: &target)

            #expect(target == expected.target)
            #expect(remainder == expected.remainder)
        }
    }

    // MARK: Self.Buy == Self.Sell
    struct BuyEqualsSell {
        @Test("Swaps contents between drain and tap", arguments: [
            (mockExchange(6, for: 8), mockExchange(8, for: 6))
        ])
        func flipped(_ sut: Exchange<Int, Int, Int>, expected: Exchange<Int, Int, Int>) {
            let result = sut.flipped
            #expect(result == expected)
        }

        @Test("Creates a drain-only exchange", arguments: [
            (mockDrain(8), mockExchange(8, for: 8))
        ])
        func drain(_ make: Transaction<Int?, Int>, expected: Exchange<Int, Int, Int>) {
            let result = Exchange<Int, Int, Int>.drain(make)
            #expect(result == expected)
        }

        @Test("Creates a tap-only exchange", arguments: [
            (mockTransaction(39), mockExchange(39, for: 39))
        ])
        func tap(_ make: Transaction<Int, Int>, expected: Exchange<Int, Int, Int>) {
            let result = Exchange<Int, Int, Int>.tap(make)
            #expect(result == expected)
        }
    }

    // MARK: Transaction (EX)
    struct TransactionTests {
        @Test("Combines two transactions together into one", arguments: [
            (mockDrain(8), mockTransaction(12), mockExchange(8, for: 12))
        ])
        func barOperator(lhs: Transaction<Int?, Int>, rhs: Transaction<Int, Int>, expected: Exchange<Int, Int, Int>) {
            let result = lhs | rhs
            #expect(result == expected)
        }
    }
}
