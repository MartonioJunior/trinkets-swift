//
//  Cronograph+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

import CustomDump
@testable import Flow
import Testing

struct CronographTests {
    @Test("Creates a new cronograph", arguments: [
        (StampOf<Int>(1, elapsed: 2), Tempo<Int>(3), CronographStatus.running, 10)
    ])
    func initializer(
        _ stamp: StampOf<Int>,
        tempo: Tempo<Int>,
        status: CronographStatus,
        source: Int
    ) {
        let sut = Cronograph(stamp, tempo: tempo, status: status) {
            source
        }

        #expect(sut.stamp == stamp)
        #expect(sut.tempo == tempo)
        #expect(sut.status == status)
        #expect(sut.source() == source)
    }

    @Test("Freezes updates")
    func freeze() {
        var sut = Cronograph<Int>(
            StampOf<Int>(1, elapsed: 2),
            tempo: Tempo<Int>(3),
            status: CronographStatus.idle,
        ) { 12 }

        expectDifference(sut) {
            sut.freeze()
        } changes: {
            $0.tempo = .halt
        }
    }

    @Test("Restarts cronograph")
    func restart() {
        var sut = Cronograph<Int>(
            StampOf<Int>(1, elapsed: 2),
            tempo: Tempo<Int>(3),
            status: CronographStatus.idle,
        ) { 12 }

        expectDifference(sut) {
            sut.restart()
        } changes: {
            $0.stamp = StampOf<Int>(1, elapsed: 0)
            $0.tempo = .forward
            $0.status = .running
        }
    }
}

extension CronographTests {
    // MARK: Self: Equatable
    struct ConformsToEquatable {
        private static func cronograph(_ values: [Int], status: CronographStatus) -> Cronograph<Int> {
            .init(
                StampOf<Int>(values[0], elapsed: values[1]),
                tempo: Tempo<Int>(values[2]),
                status: status,
            ) { values[3] }
        }

        @Test("Compares start, stamp, tempo and status", arguments: [
            (cronograph([1, 2, 3, 4], status: .idle), cronograph([1, 2, 3, 4], status: .idle), true),
            (cronograph([1, 2, 3, 6], status: .idle), cronograph([1, 2, 3, 7], status: .idle), true),
            (cronograph([1, 2, 3, 4], status: .idle), cronograph([1, 2, 7, 4], status: .idle), false),
            (cronograph([1, 2, 3, 4], status: .idle), cronograph([1, 8, 3, 4], status: .idle), false),
            (cronograph([1, 2, 3, 4], status: .idle), cronograph([0, 2, 3, 4], status: .idle), false),
            (cronograph([1, 2, 3, 4], status: .idle), cronograph([1, 2, 3, 4], status: .running), false)
        ])
        func equals(lhs: Cronograph<Int>, rhs: Cronograph<Int>, expected: Bool) {
            let result = lhs == rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Metronome
    struct ConformsToMetronome {
        @Test("Updates cronograph by tempo")
        func tick() {
            let caseIdle = Cronograph(.init(startedAt: 3), status: .idle) { 7 }
            expectNoChanges(caseIdle) {
                $0.tick()
            }

            var caseRunning = Cronograph(.init(startedAt: 3), status: .running) { 7 }
            expectDifference(caseRunning) {
                caseRunning.tick()
            } changes: {
                $0.stamp = StampOf<Int>(7, elapsed: 4)
            }

            var casePaused = Cronograph(.init(startedAt: 3), status: .paused) { 7 }
            expectDifference(casePaused) {
                casePaused.tick()
            } changes: {
                $0.stamp = StampOf<Int>(startedAt: 7)
            }
        }
    }

    // MARK: Self: Pausable
    struct ConformsToPausable {
        @Test("Pauses the cronograph")
        func pause() {
            var sut = Cronograph(.init(startedAt: 3), status: .idle) { 7 }
            expectDifference(sut) {
                sut.pause()
            } changes: {
                $0.status = .paused
            }
        }
    }

    // MARK: Self: Resumable
    struct ConformsToResumable {
        @Test("Resumes the cronograph")
        func resume() {
            let caseIdle = Cronograph(.init(startedAt: 3), status: .idle) { 7 }
            expectNoChanges(caseIdle) {
                $0.resume()
            }

            let caseRunning = Cronograph(.init(startedAt: 3), status: .running) { 7 }
            expectNoChanges(caseRunning) {
                $0.resume()
            }

            var casePaused = Cronograph(.init(startedAt: 3), status: .paused) { 7 }
            expectDifference(casePaused) {
                casePaused.resume()
            } changes: {
                $0.status = .running
            }
        }
    }

    // MARK: Self: Stoppable
    struct ConformsToStoppable {
        @Test("Stops the cronograph")
        func stop() {
            var sut = Cronograph(.init(startedAt: 3), status: .running) { 7 }

            expectDifference(sut) {
                sut.stop()
            } changes: {
                $0.status = .idle
                $0.stamp = StampOf(startedAt: 3)
            }

            expectNoChanges(sut) {
                $0.stop()
            }
        }
    }
}
