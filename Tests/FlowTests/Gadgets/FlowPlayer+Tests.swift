//
//  FlowPlayer+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

import CustomDump
@testable import Flow
import Testing

struct FlowPlayerTests {
    @Test("Creates a new Flow Player", arguments: [
        (
            Cronograph<Int>(.init(startedAt: 4)) { 7 },
            Playback(.fixed(12), wrap: .reset)
        )
    ])
    func initializer(
        _ cronograph: Cronograph<Int>,
        settings playback: Playback
    ) {
        let sut = FlowPlayer<Int, Int>(cronograph, settings: playback) { $0 }
        #expect(sut.cronograph == cronograph)
        #expect(sut.playback == playback)
    }

    @Test("Elapsed time for the player", arguments: [
        (
            FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            ),
            5
        )
    ])
    func elapsed(_ sut: FlowPlayer<Int, Int>, expected: Int) {
        #expect(sut.elapsed == expected)
    }

    @Test("Tempo for the player", arguments: [
        (Tempo<Int>(-3), Tempo<Int>(-3))
    ])
    func tempo(_ newValue: Tempo<Int>, expected: Tempo<Int>) {
        var sut = FlowPlayer<Int, Int>(
            Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
            settings: Playback(.fixed(12), wrap: .reset),
            \.self
        )

        expectDifference(sut) {
            sut.tempo = newValue
        } changes: {
            $0.tempo = newValue
        }

        #expect(sut.tempo == expected)
    }

    // MARK: Methods
    @Test("Obtains sampled state")
    func consume() {
        let notRunning = FlowPlayer<Int, Int>(
            Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), source: { 22 }),
            settings: Playback(.fixed(12), wrap: .reset),
            \.self
        )

        expectNoChanges(notRunning) {
            let result = $0.consume(\.elapsed, transform: \.self)
            #expect(result == nil)
        }

        var runningWithLoop = FlowPlayer<Int, Int>(
            Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
            settings: Playback(.fixed(12), wrap: .reset),
            \.self
        )

        expectDifference(runningWithLoop) {
            let result = runningWithLoop.consume(\.elapsed, transform: \.self)
            #expect(result == 5)
        } changes: {
            $0.cronograph = Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 0), status: .running, source: { 22 })
            $0.playback = Playback(.fixed(11), wrap: .reset)
        }

        var runningWithoutLoop = FlowPlayer<Int, Int>(
            Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
            settings: Playback(.fixed(0), wrap: .reset),
            \.self
        )

        expectDifference(runningWithoutLoop) {
            let result = runningWithoutLoop.consume(\.elapsed, transform: \.self)
            #expect(result == 5)
        } changes: {
            $0.cronograph = Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 0), status: .idle, source: { 22 })
            $0.playback = Playback(.fixed(0), wrap: .reset)
        }
    }

    @Test("Obtains instant state")
    func consumeInstant() {
        var sut = FlowPlayer<Int, Int>(
            Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
            settings: Playback(.fixed(12), wrap: .reset),
            \.self
        )

        expectDifference(sut) {
            let result = sut.consumeInstant(\.self)
            #expect(result == 3)
        } changes: {
            $0.cronograph = Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 0), status: .running, source: { 22 })
            $0.playback = Playback(.fixed(11), wrap: .reset)
        }

        var withoutLooping = FlowPlayer<Int, Int>(
            Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
            settings: Playback(.fixed(0), wrap: .reset),
            \.self
        )

        expectDifference(withoutLooping) {
            let result = withoutLooping.consumeInstant(\.self)
            #expect(result == 3)
        } changes: {
            $0.cronograph = Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 0), status: .idle, source: { 22 })
            $0.playback = Playback(.fixed(0), wrap: .reset)
        }
    }

    @Test("Obtains value sample", arguments: [
        (
            FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            ),
            5
        )
    ])
    func sample(_ sut: FlowPlayer<Int, Int>, expected: Int) {
        let result = sut.sample(by: \.elapsed)
        #expect(result == expected)
    }
}

extension FlowPlayerTests {
    // MARK: Self: Equatable
    struct ConformsToEquatable {
        static func player(_ values: [Int], wrap: Playback.Wrap) -> FlowPlayer<Int, Int> {
            .init(
                Cronograph<Int>(Stamp<Int, Int>(values[0], elapsed: values[1]), source: { values[2] }),
                settings: Playback(.endless, wrap: wrap),
                \.self
            )
        }
        @Test("Compares cronograph and playback", arguments: [
            (player([1, 2, 3], wrap: .reset), player([1, 2, 3], wrap: .reset), true),
            (player([1, 2, 3], wrap: .reset), player([1, 2, 3], wrap: .freeze), false),
            (player([1, 2, 3], wrap: .reset), player([5, 2, 3], wrap: .reset), false),
            (player([1, 2, 3], wrap: .reset), player([1, 8, 3], wrap: .reset), false),
            (player([1, 2, 3], wrap: .reset), player([1, 2, 7], wrap: .reset), true)
        ])
        func equals(lhs: FlowPlayer<Int, Int>, rhs: FlowPlayer<Int, Int>, expected: Bool) {
            let result = lhs == rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Metronome
    struct ConformsToMetronome {
        @Test("Applies tick to player")
        func tick() {
            let idle = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )
            expectNoChanges(idle) {
                $0.tick()
            }

            let idleMulti = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )
            expectNoChanges(idleMulti) {
                $0.tick(by: .fast(.forward, x: 4))
            }

            var running = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )

            expectDifference(running) {
                running.tick()
            } changes: {
                $0.cronograph.tick()
            }

            var runningMulti = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )

            expectDifference(runningMulti) {
                runningMulti.tick(by: Tempo<Int>(3))
            } changes: {
                $0.cronograph.tick(by: Tempo<Int>(3))
            }
        }
    }

    // MARK: Self: Operational
    struct ConformsToOperational {
        @Test("Defines a new status", arguments: [
            (
                FlowPlayer<Int, Int>(
                    Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: CronographStatus.paused, source: { 22 }),
                    settings: Playback(.fixed(12), wrap: .reset),
                    \.self
                ),
                CronographStatus.paused
            )
        ])
        func status(_ sut: FlowPlayer<Int, Int>, expected: CronographStatus) {
            #expect(sut.status == expected)
        }
    }

    // MARK: Self: Pausable
    struct ConformsToPausable {
        @Test("Pauses the player")
        func pause() {
            var sut = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )

            expectDifference(sut) {
                sut.pause()
            } changes: {
                $0.cronograph.pause()
            }
        }
    }

    // MARK: Self: Resumable
    struct ConformsToResumable {
        @Test("Resumes the player")
        func resume() {
            var sut = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .paused, source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )

            expectDifference(sut) {
                sut.resume()
            } changes: {
                $0.cronograph.resume()
            }
        }
    }

    // NARK: Self: Skippable
    struct ConformsToSkippable {
        @Test("Skips an iteration when there's loops")
        func skip_loop() {
            var sut = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .paused, source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )
            expectDifference(sut) {
                sut.skip()
            } changes: {
                $0.cronograph.restart()
                $0.playback = Playback(.fixed(11), wrap: .reset)
            }
        }

        @Test("Freeze wrap freezes on skip")
        func skip_freezeWrap() {
            var sut = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .paused, source: { 22 }),
                settings: Playback(.fixed(0), wrap: .freeze),
                \.self
            )
            expectDifference(sut) {
                sut.skip()
            } changes: {
                $0.cronograph.freeze()
            }
        }

        @Test("Hold wrap pauses on skip")
        func skip_holdWrap() {
            var caseHoldWrap = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
                settings: Playback(.fixed(0), wrap: .hold),
                \.self
            )
            expectDifference(caseHoldWrap) {
                caseHoldWrap.skip()
            } changes: {
                $0.cronograph.pause()
            }
        }

        @Test("Reset wrap stops on skip")
        func skip_resetWrap() {
            var caseResetWrap = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .paused, source: { 22 }),
                settings: Playback(.fixed(0), wrap: .reset),
                \.self
            )
            expectDifference(caseResetWrap) {
                caseResetWrap.skip()
            } changes: {
                $0.cronograph.stop()
            }
        }

        @Test("No wrapping does nothing on skip")
        func skip_noWrap() {
            let caseNoWrap = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .paused, source: { 22 }),
                settings: Playback(.fixed(0), wrap: nil),
                \.self
            )
            expectNoChanges(caseNoWrap) {
                $0.skip()
            }
        }
    }

    // MARK: Self: Stoppable
    struct ConformsToStoppable {
        @Test("Stops the player")
        func stop() {
            var sut = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .paused, source: { 22 }),
                settings: Playback(.fixed(0), wrap: .reset),
                \.self
            )
            expectDifference(sut) {
                sut.stop()
            } changes: {
                $0.cronograph.stop()
            }
        }
    }

    // MARK: Self.Instant == Self.Interval
    struct InstantEqualsInterval {
        @Test("Obtains interval state")
        func consumeInterval() {
            var looping = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
                settings: Playback(.fixed(12), wrap: .reset),
                \.self
            )

            expectDifference(looping) {
                let result = looping.consumeInterval(\.self)
                #expect(result == 5)
            } changes: {
                $0.cronograph = Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 0), status: .running, source: { 22 })
                $0.playback = Playback(.fixed(11), wrap: .reset)
            }

            var notLooping = FlowPlayer<Int, Int>(
                Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 5), status: .running, source: { 22 }),
                settings: Playback(.fixed(0), wrap: .reset),
                \.self
            )

            expectDifference(notLooping) {
                let result = notLooping.consumeInterval(\.self)
                #expect(result == 5)
            } changes: {
                $0.cronograph = Cronograph<Int>(Stamp<Int, Int>(3, elapsed: 0), status: .idle, source: { 22 })
                $0.playback = Playback(.fixed(0), wrap: .reset)
            }
        }
    }
}
