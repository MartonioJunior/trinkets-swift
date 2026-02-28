//
//  Trader+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 25/03/2026.
//

@testable import Exchanges
import Testing

// MARK: Mocks
struct MockTrader: Trader, Equatable, Sendable {
    mutating func buy(_ contents: Int) -> Int? { contents }
    mutating func sell(_ contents: Int) -> Int? { contents }
}

struct TraderTests {
    // MARK: Default Implementation
    @Test("Performs a purchase multiple times", arguments: [
        (repeatElement(3, count: 5), [3, 3, 3, 3, 3])
    ])
    func buyMany(_ contents: Repeated<Int>, expected: [Int]) {
        var sut = MockTrader()
        let result = sut.buyMany(contents)
        #expect(result == expected)
    }

    @Test("Performs a sale multiple times", arguments: [
        (repeatElement(2, count: 3), [2, 2, 2])
    ])
    func sellMany(_ contents: Repeated<Int>, expected: [Int]) {
        var sut = MockTrader()
        let result = sut.sellMany(contents)
        #expect(result == expected)
    }
}
