//
//  Counter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

@testable import Flow
import Testing

struct CounterTests {
    @Test("Creates a new counter", arguments: [
        (2, Tempo<Int>.forward)
    ])
    func initializer(_ count: Int, jump: Tempo<Int>) {
        let result = Counter(count, jump: jump)
        #expect(result.count == count)
        #expect(result.jump == jump)
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        @Test("Creates a traditional forward counter", arguments: [
            (15, Counter(15, jump: .forward))
        ])
        func initializer(integerLiteral value: Int, expected: Counter) {
            let result = Counter(integerLiteral: value)
            #expect(result == expected)
        }
    }

    // MARK: Self: Metronome
    struct ConformsToMetronome {
        @Test("Combines jump and tempo into a single structure", arguments: [
            (Counter(4, jump: 3), Tempo<Int>(2), Counter(10, jump: 3))
        ])
        func tick(_ sut: Counter, by tempo: Tempo<Int>, expected: Counter) {
            var sut = sut
            sut.tick(by: tempo)
            #expect(sut == expected)
        }
    }

    // MARK: Self: Strideable
    struct ConformsToStrideable {
        @Test("Advances counter by amount", arguments: [
            (Counter(55, jump: -4), 12, Counter(67, jump: -4))
        ])
        func advanced(_ sut: Counter, by n: Int, expected: Counter) {
            let result = sut.advanced(by: n)
            #expect(result == expected)
        }

        @Test("Distance between two counters", arguments: [
            (Counter(12, jump: -3), Counter(15, jump: 2), 3)
        ])
        func distance(_ sut: Counter, to other: Counter, expected: Int) {
            let result = sut.distance(to: other)
            #expect(result == expected)
        }
    }
}
