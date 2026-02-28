//
//  Metronome+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2026.
//

@testable import Flow
import Testing

struct MetronomeTests {
    struct Mock: Metronome, Equatable, Sendable {
        var count: Int

        mutating func tick(by tempo: Tempo<Int>) {
            count += tempo.multiplier
        }
    }

    // MARK: Default Implementation
    @Test("Updates metronome based on Async sequence")
    func refresh() async throws {
        let sequenceA = AsyncStream<Int> { continuation in
            Task {
                var current = 1
                while current < 50 {
                    continuation.yield(current)
                    current *= 2
                }
                continuation.finish()
            }
        }
        var sut = Mock(count: 0)
        try await sut.refresh(basedOn: sequenceA)
        let expected = Mock(count: 6)
        #expect(sut == expected)
    }

    @Test("Updates metronome based on Async sequence")
    func refresh_withPacking() async throws {
        let sequenceA = AsyncStream<Int> { continuation in
            Task {
                for i in 1...10 {
                    continuation.yield(i)
                }
                continuation.finish()
            }
        }
        var sut = Mock(count: 0)
        try await sut.refresh(basedOn: sequenceA) {
            $0.isMultiple(of: 4) ? .fastForward(x: 3) : 1
        }
        let expected = Mock(count: 14)
        #expect(sut == expected)
    }

    @Test("Default implementation of `tick()`", arguments: [
        (Mock(count: 0), Mock(count: 1)),
        (Mock(count: 12), Mock(count: 13))
    ])
    func tick(_ sut: Mock, expected: Mock) {
        var sut = sut
        sut.tick()
        #expect(sut == expected)
    }

    // MARK: MutableCollection (EX)
    struct MutableCollectionTests {
        @Test("Updates state for multiple metronomes", arguments: [
            ([Mock(count: 3), Mock(count: 8)], [Mock(count: 4), Mock(count: 9)])
        ])
        func tick(_ sut: [Mock], expected: [Mock]) {
            var sut = sut
            sut.tick()
            #expect(sut == expected)
        }

        @Test("Updates state for multiple metronomes", arguments: [
            ([Mock(count: 3), Mock(count: 8)], Tempo<Int>(1), [Mock(count: 4), Mock(count: 9)]),
            ([Mock(count: 3), Mock(count: 8)], Tempo<Int>(3), [Mock(count: 6), Mock(count: 11)]),
            ([Mock(count: 3), Mock(count: 8)], Tempo<Int>(-4), [Mock(count: -1), Mock(count: 4)]),
            ([Mock(count: 3), Mock(count: 8)], Tempo<Int>(0), [Mock(count: 3), Mock(count: 8)])
        ])
        func tick(_ sut: [Mock], by tempo: Tempo<Mock.Value>, expected: [Mock]) {
            var sut = sut
            sut.tick(by: tempo)
            #expect(sut == expected)
        }
    }
}
