//
//  Stamp+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2026.
//

@testable import Flow
import Testing

struct StampTests {
    @Test("Creates a new stamp", arguments: [
        (12, 4)
    ])
    func initializer(_ reference: Int, elapsed: Int) {
        let result = Stamp(reference, elapsed: elapsed)
        #expect(result.reference == reference)
        #expect(result.elapsed == elapsed)
    }

    // MARK: Self.Instant: Strideable
    struct InstantConformsToStrideable {
        @Test("Range represented by stamp", arguments: [
            (StampOf<Int>(12, elapsed: 24), 12...36),
            (StampOf<Int>(12, elapsed: -6), 6...12),
            (StampOf<Int>(12, elapsed: 0), 12...12)
        ])
        func range(_ sut: Stamp<Int, Int>, expected: ClosedRange<Int>) {
            #expect(sut.range == expected)
        }

        @Test("Moves back the stamp by interval", arguments: [
            (Stamp(12, elapsed: 24), 5, Stamp(7, elapsed: 19))
        ])
        func backtrack(_ sut: Stamp<Int, Int>, by interval: Int, expected: Stamp<Int, Int>) {
            var sut = sut
            sut.backtrack(by: interval)
            #expect(sut == expected)
        }

        @Test("Advances the stamp by interval", arguments: [
            (Stamp(12, elapsed: 24), 5, Stamp(17, elapsed: 29))
        ])
        func advance(_ sut: Stamp<Int, Int>, by newDelta: Int, expected: Stamp<Int, Int>) {
            var sutA = sut
            sutA.advance(by: newDelta)
            #expect(sutA == expected)
        }

        @Test("Advances the stamp to an instant", arguments: [
            (Stamp(12, elapsed: 24), 22, Stamp(22, elapsed: 34))
        ])
        func advance(_ sut: Stamp<Int, Int>, to newInstant: Int, expected: Stamp<Int, Int>) {
            var sut = sut
            sut.advance(to: newInstant)
            #expect(sut == expected)
        }
    }

    // MARK: Self.Interval: AdditiveArithmetic
    struct IntervalConformsToAdditiveArithmetic {
        @Test("Creates a new stamp with zero elapsed interval.", arguments: [
            (5, Stamp(5, elapsed: 0))
        ])
        func initializer(startedAt: Int, expected: Stamp<Int, Int>) {
            let result = Stamp<Int, Int>(startedAt: startedAt)
            #expect(result == expected)
        }

        @Test("Resets stamp to given instant", arguments: [
            (Stamp(12, elapsed: 15), 21, Stamp(21, elapsed: 0)),
            (Stamp(12, elapsed: 15), 12, Stamp(12, elapsed: 0)),
            (Stamp(12, elapsed: 15), 4, Stamp(4, elapsed: 0))
        ])
        func restart(_ sut: Stamp<Int, Int>, at instant: Int, expected: Stamp<Int, Int>) {
            var sut = sut
            sut.restart(at: instant)
            #expect(sut == expected)
        }

        @Test("Resets stamp interval only", arguments: [
            (Stamp(3, elapsed: 7), Stamp(3, elapsed: 0)),
            (Stamp(12, elapsed: 0), Stamp(12, elapsed: 0))
        ])
        func resetIntervalOnly(_ sut: Stamp<Int, Int>, expected: Stamp<Int, Int>) {
            var sut = sut
            sut.resetIntervalOnly()
            #expect(sut == expected)
        }
    }

    // MARK: Self.Interval: SignedNumeric
    struct IntervalConformsToSignedNumeric {
        @Test("Mutliplies stamp with tempo", arguments: [
            (Stamp(8, elapsed: 4), Tempo<Int>(3), Stamp(8, elapsed: 12)),
            (Stamp(8, elapsed: -4), Tempo<Int>(3), Stamp(8, elapsed: -12)),
            (Stamp(8, elapsed: 4), Tempo<Int>(-3), Stamp(8, elapsed: -12)),
            (Stamp(8, elapsed: 0), Tempo<Int>(3), Stamp(8, elapsed: 0)),
            (Stamp(8, elapsed: 4), Tempo<Int>(0), Stamp(8, elapsed: 0))
        ])
        func multiply(lhs: Stamp<Int, Int>, rhs: Tempo<Int>, expected: Stamp<Int, Int>) {
            let result = lhs * rhs
            #expect(result == expected)
        }
    }

    // MARK: AsyncSequence (EX)
    struct AsyncSequenceTests {
        @Test("Streams generated stamps for async sequence")
        func stampedBy() async {
            let sut = AsyncStream<Int> { continuation in
                Task {
                    for i in 1...4 {
                        continuation.yield(i)
                    }
                    continuation.finish()
                }
            }

            let result = await sut.stamped {
                $1 + $0 * 2
            }.reduce(into: [Stamp<Int, Int>]()) {
                $0.append($1)
            }

            let expected: [Stamp<Int, Int>] = [
                Stamp(1, elapsed: 3),
                Stamp(2, elapsed: 4),
                Stamp(3, elapsed: 7),
                Stamp(4, elapsed: 10)
            ]
            #expect(result == expected)
        }

        @Test("Streams generated stamps for async sequence")
        func stamped() async {
            let sut = AsyncStream<Int> { continuation in
                Task {
                    for i in 5...8 {
                        continuation.yield(i)
                    }
                    continuation.finish()
                }
            }
            let result = await sut.stamped.reduce(into: [Stamp<Int, Int>]()) {
                $0.append($1)
            }
            let expected: [Stamp<Int, Int>] = [
                Stamp(5, elapsed: 0),
                Stamp(6, elapsed: 1),
                Stamp(7, elapsed: 1),
                Stamp(8, elapsed: 1)
            ]
            #expect(result == expected)
        }
    }
}
