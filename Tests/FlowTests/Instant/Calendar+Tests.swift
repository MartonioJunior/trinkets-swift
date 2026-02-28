//
//  Calendar+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

@testable import Flow
import Testing

struct CalendarTests {
    @Test("Creates a new calendar", arguments: [
        (4)
    ])
    func initializer(epoch: Int) {
        let result = Calendar(epoch: epoch)
        #expect(result.epoch == epoch)
    }

    @Test("Interval to a given instant", arguments: [
        (Calendar<Int>(epoch: 12), 82, 70),
        (Calendar<Int>(epoch: 12), 8, -4),
    ])
    func intervalSinceEpoch(_ sut: Calendar<Int>, for instant: Int, expected: Int) {
        let resultA = sut.intervalSinceEpoch(for: instant)
        #expect(resultA == expected)

        let resultB = sut.intervalSinceEpoch(for: instant) { $0.distance(to: $1) }
        #expect(resultB == expected)
    }

    @Test("Creates a range of activity for a stopwatch", arguments: [
        (Calendar<Int>(epoch: 12), 20, 12...32),
        (Calendar<Int>(epoch: 12), 12, 12...24),
        (Calendar<Int>(epoch: 12), -4, ClosedRange<Int>?.none)
    ])
    func range(_ sut: Calendar<Int>, after interval: Int, expected: ClosedRange<Int>?) {
        let resultA = sut.range(after: interval)
        #expect(resultA == expected)

        let resultB = sut.range(after: interval) { $0.advanced(by: $1) }
        #expect(resultB == expected)
    }

    @Test("Creates a new stamp", arguments: [
        (Calendar<Int>(epoch: 1), 8, Stamp<Int, Int>(8, elapsed: 7)),
        (Calendar<Int>(epoch: 4), 2, Stamp<Int, Int>(2, elapsed: -2)),
        (Calendar<Int>(epoch: 3), -2, Stamp<Int, Int>(-2, elapsed: -5)),
        (Calendar<Int>(epoch: -8), -5, Stamp<Int, Int>(-5, elapsed: 3))
    ])
    func stamp(_ sut: Calendar<Int>, _ instant: Int, expected: Stamp<Int, Int>) {
        let resultA = sut.stamp(instant)
        #expect(resultA == expected)

        let resultB = sut.stamp(instant) { $0.distance(to: $1) }
        #expect(resultB == expected)
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Calendars are ordered based on epoch", arguments: [
            (Calendar<Int>(epoch: 7), Calendar<Int>(epoch: 14), true),
            (Calendar<Int>(epoch: 7), Calendar<Int>(epoch: 2), false)
        ])
        func lesserThan(lhs: Calendar<Int>, rhs: Calendar<Int>, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Strideable
    struct ConformsToStrideable {
        @Test("Advances epoch internally", arguments: [
            (Calendar<Int>(epoch: 12), 4, Calendar<Int>(epoch: 16)),
            (Calendar<Int>(epoch: 12), -5, Calendar<Int>(epoch: 7))
        ])
        func advanced(_ sut: Calendar<Int>, by n: Int, expected: Calendar<Int>) {
            let result = sut.advanced(by: n)
            #expect(result == expected)
        }

        @Test("Calculates distance between epochs", arguments: [
            (Calendar<Int>(epoch: 12), Calendar<Int>(epoch: 22), 10),
            (Calendar<Int>(epoch: 35), Calendar<Int>(epoch: 26), -9)
        ])
        func distance(_ sut: Calendar<Int>, to other: Calendar<Int>, expected: Int) {
            let result = sut.distance(to: other)
            #expect(result == expected)
        }
    }

    // MARK: AsyncSequence (EX)
    struct AsyncSequenceTests {
        @Test("Streams generated stamps of the calendar", arguments: [
            (Calendar<Int>(epoch: 12), [
                Stamp<Int, Int>(19, elapsed: 14),
                Stamp<Int, Int>(20, elapsed: 16),
                Stamp<Int, Int>(21, elapsed: 18),
                Stamp<Int, Int>(22, elapsed: 20)
            ])
        ])
        func stampedDistance(using calendar: Calendar<Int>, expected: [Stamp<Int, Int>]) async {
            let sut = AsyncStream<Int> { continuation in
                Task {
                    for i in 19...22 {
                        continuation.yield(i)
                    }
                    continuation.finish()
                }
            }

            let result = await sut.stamped(using: calendar) {
                ($1 - $0) * 2
            }.reduce(into: [Stamp<Int, Int>]()) {
                $0.append($1)
            }

            #expect(result == expected)
        }

        @Test("Streams generated stamps of the calendar", arguments: [
            (Calendar<Int>(epoch: 12), [
                Stamp<Int, Int>(19, elapsed: 7),
                Stamp<Int, Int>(20, elapsed: 8),
                Stamp<Int, Int>(21, elapsed: 9),
                Stamp<Int, Int>(22, elapsed: 10)
            ])
        ])
        func stamped(using calendar: Calendar<Int>, expected: [Stamp<Int, Int>]) async {
            let sut = AsyncStream<Int> { continuation in
                Task {
                    for i in 19...22 {
                        continuation.yield(i)
                    }
                    continuation.finish()
                }
            }

            let result = await sut.stamped(using: calendar).reduce(into: [Stamp<Int, Int>]()) {
                $0.append($1)
            }

            #expect(result == expected)
        }
    }
}
