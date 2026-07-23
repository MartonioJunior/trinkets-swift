//
//  Stopwatch+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

@testable import Flow
import Testing

struct StopwatchTests {
    @Test("Creates a new stopwatch", arguments: [
        (12)
    ])
    func initializer(elapsed: Int) {
        let result = Stopwatch(elapsed: elapsed)
        #expect(result.elapsed == elapsed)
    }

    @Test("Calculates current instant based on calendar", arguments: [
        (Stopwatch<Int>(elapsed: 15), Calendar<Int>(epoch: 9), 24),
        (Stopwatch<Int>(elapsed: 0), Calendar<Int>(epoch: 9), 9),
    ])
    func instant(_ sut: Stopwatch<Int>, basedOn calendar: Calendar<Int>, expected: Int) {
        let resultA = sut.instant(basedOn: calendar)
        #expect(resultA == expected)

        let resultB = sut.instant(basedOn: calendar) { $0.advanced(by: $1) }
        #expect(resultB == expected)
    }

    @Test("Calculates remaining interval until instant", arguments: [
        (Stopwatch<Int>(elapsed: 15), Calendar<Int>(epoch: 9), 30, 6),
        (Stopwatch<Int>(elapsed: 0), Calendar<Int>(epoch: 9), 30, 21),
        (Stopwatch<Int>(elapsed: -4), Calendar<Int>(epoch: 9), 30, 25),
        (Stopwatch<Int>(elapsed: 15), Calendar<Int>(epoch: 9), 20, -4),
    ])
    func remaining(_ sut: Stopwatch<Int>, from calendar: Calendar<Int>, until instant: Int, expected: Int) {
        let resultA = sut.remaining(from: calendar, until: instant)
        #expect(resultA == expected)

        let resultB = sut.remaining(from: calendar, until: instant) { $0.distance(to: $1) }
        #expect(resultB == expected)
    }

    // MARK: Self.Interval: AdditiveArithmetic
    struct IntervalConformsToAdditiveArithmetic {
        @Test("Advances elapsed state by amount", arguments: [
            (Stopwatch<Int>(elapsed: 12), 3, Stopwatch<Int>(elapsed: 15)),
            (Stopwatch<Int>(elapsed: 12), -3, Stopwatch<Int>(elapsed: 9)),
            (Stopwatch<Int>(elapsed: 0), 3, Stopwatch<Int>(elapsed: 3)),
            (Stopwatch<Int>(elapsed: 6), 0, Stopwatch<Int>(elapsed: 6))
        ])
        func advance(_ sut: Stopwatch<Int>, by interval: Int, expected: Stopwatch<Int>) async throws {
            var sut = sut
            sut.advance(by: interval)
            #expect(sut == expected)
        }
    }
}
