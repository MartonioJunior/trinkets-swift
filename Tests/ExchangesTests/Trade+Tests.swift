//
//  Trade+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/03/2026.
//

@testable import Exchanges
import Testing

func mockTrade(_ buy: Int, for sell: Int) -> Trade<MockTrader, MockTrader> {
    .init(TradeTests.mockExchange(buy, for: sell), to: TradeTests.mockExchange(sell, for: buy))
}

struct TradeTests {
    static func mockExchange(_ buy: Int, for sell: Int) -> Exchange<MockTrader, Int, Int> {
        .init(drain: .init(buy) { _, _ in
            nil
        }, tap: .init(sell) { _, _ in
            nil
        })
    }

    // MARK: Initializers
    @Test("Creates a new trade", arguments: [
        (mockExchange(4, for: 9), mockExchange(5, for: 7))
    ])
    func initializer(_ buyer: Exchange<MockTrader, Int, Int>, to seller: Exchange<MockTrader, Int, Int>) {
        let result = Trade<MockTrader, MockTrader>(buyer, to: seller)
        #expect(result.buyer == buyer)
        #expect(result.seller == seller)
    }

    // MARK: Methods
    @Test("Moves contents from buyer to seller", arguments: [
        (
            mockTrade(6, for: 12), MockTrader(), MockTrader(),
            (remainder: (buyer: Int?.none, seller: Int?.none), purchaser: MockTrader(), supplier: MockTrader())
        )
    ])
    func drain(
        _ sut: Trade<MockTrader, MockTrader>,
        from purchaser: MockTrader,
        to supplier: MockTrader,
        expected: (remainder: (buyer: Int?, seller: Int?), purchaser: MockTrader, supplier: MockTrader)
    ) {
        var purchaser = purchaser
        var supplier = supplier
        let remainder = sut.drain(from: &purchaser, to: &supplier)

        #expect(remainder == expected.remainder)
        #expect(purchaser == expected.purchaser)
        #expect(supplier == expected.supplier)
    }

    @Test("Moves contents from seller to buyer", arguments: [
        (
            mockTrade(9, for: 4), MockTrader(), MockTrader(),
            (remainder: (buyer: Int?.none, seller: Int?.none), purchaser: MockTrader(), supplier: MockTrader())
        )
    ])
    func tap(
        _ sut: Trade<MockTrader, MockTrader>,
        _ purchaser: MockTrader,
        using supplier: MockTrader,
        expected: (remainder: (buyer: Int?, seller: Int?), purchaser: MockTrader, supplier: MockTrader)
    ) {
        var purchaser = purchaser
        var supplier = supplier
        let remainder = sut.tap(&purchaser, using: &supplier)

        #expect(remainder == expected.remainder)
        #expect(purchaser == expected.purchaser)
        #expect(supplier == expected.supplier)
    }

    @Test("Exchanges contents between purchaser and supplier", arguments: [
        (
            mockTrade(9, for: 4), MockTrader(), MockTrader(),
            (
                remainder: Trade<MockTrader, MockTrader>.Remainder?.none,
                purchaser: MockTrader(), supplier: MockTrader()
            )
        )
    ])
    func trade(
        _ sut: Trade<MockTrader, MockTrader>,
        between purchaser: MockTrader,
        and supplier: MockTrader,
        expected: (remainder: Trade<MockTrader, MockTrader>.Remainder?, purchaser: MockTrader, supplier: MockTrader)
    ) {
        var purchaser = purchaser
        var supplier = supplier
        let remainder = sut.trade(between: &purchaser, and: &supplier)

        #expect(remainder == expected.remainder)
        #expect(purchaser == expected.purchaser)
        #expect(supplier == expected.supplier)
    }

    // MARK: Self.Remainder
    struct RemainderTests {
        @Test("Creates a new remainder", arguments: [
            (Exchange<MockTrader, Int, Int>.Remainder(buy: 2, sell: 4), Exchange<MockTrader, Int, Int>.Remainder(buy: 2, sell: 4)),
            (nil, Exchange<MockTrader, Int, Int>.Remainder(buy: 2, sell: 4)),
            (Exchange<MockTrader, Int, Int>.Remainder(buy: 2, sell: 4), nil),
            (nil, nil)
        ])
        func initializer(_ buyer: Exchange<MockTrader, Int, Int>.Remainder?, seller: Exchange<MockTrader, Int, Int>.Remainder?) {
            let result = Trade<MockTrader, MockTrader>.Remainder(buyer, seller: seller)

            if buyer == nil {
                #expect(result == nil)
            } else {
                #expect(result?.buyer == buyer)
                #expect(result?.seller == seller)
            }
        }
    }

    // MARK: A.Buy == B.Sell
    struct ABuyEqualsBSell {
        @Test("Swaps buyer with seller", arguments: [
            (mockTrade(3, for: 9), mockTrade(9, for: 3))
        ])
        func reversed(_ sut: Trade<MockTrader, MockTrader>, expected: Trade<MockTrader, MockTrader>) {
            let result = sut.reversed
            #expect(result == expected)
        }
    }

    // MARK: A == B
    struct AEqualsB {
        @Test("Creates a trade from one exchange instance", arguments: [
            (mockExchange(4, for: 9), mockTrade(4, for: 9))
        ])
        func flow(_ exchange: Exchange<MockTrader, Int, Int>, expected: Trade<MockTrader, MockTrader>) {
            let result = Trade.flow(exchange)
            #expect(result == expected)
        }

        @Test("Creates a new trade by extrapolating an exchange's contents", arguments: [
            (mockExchange(3, for: 6), Trade(mockExchange(3, for: 6), to: mockExchange(9, for: 18)))
        ])
        func initializer(_ exchange: Exchange<MockTrader, Int, Int>, expected: Trade<MockTrader, MockTrader>) {
            let result = Trade(exchange, receives: triple, offers: triple)
            #expect(result == expected)

            func triple(_ value: Int) -> Int {
                value * 3
            }
        }
    }
}
