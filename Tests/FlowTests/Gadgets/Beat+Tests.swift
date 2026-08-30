//
//  Beat+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

@testable import Flow
import Testing

struct BeatTests {
    @Test("Creates new beat", arguments: [
        (Calendar<Int>(epoch: 9), Timing(carry: 1, coyote: 2))
    ])
    func initializer(_ calendar: Calendar<Int>, timing: Timing<Int>) {
        let result = Beat(calendar, timing: timing)
        #expect(result.calendar == calendar)
        #expect(result.timing == timing)
    }

    // MARK: Methods
    @Test("Beat with same timing, but a different instant", arguments: [
        (
            BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
            24, BeatOf<Int>(.init(epoch: 24), timing: .init(carry: 1, coyote: 2))
        )
    ])
    func repositioned(_ sut: BeatOf<Int>, at instant: Int, expected: BeatOf<Int>) {
        let result = sut.repositioned(at: instant)
        #expect(result == expected)
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Compares two beats based on calendar", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 19), timing: .init(carry: 1, coyote: 2)),
                true
            ),
            (
                BeatOf<Int>(.init(epoch: 19), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 19), timing: .init(carry: 1, coyote: 2)),
                false
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 10, coyote: 20)),
                BeatOf<Int>(.init(epoch: 6), timing: .zero),
                false
            )
        ])
        func lesserThan(lhs: Beat<Int, Int>, rhs: Beat<Int, Int>, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Selectable
    struct ConformsToSelectable {
        @Test("Describes how range can select beats", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 10, coyote: 20)),
                4...28, true
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 10, coyote: 20)),
                4...8, false
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 10, coyote: 20)),
                35...44, false
            )
        ])
        func canBeSelected(_ sut: Beat<Int, Int>, by selection: ClosedRange<Int>, expected: Bool) {
            let result = sut.canBeSelected(by: selection)
            #expect(result == expected)
        }
    }

    // MARK: Self: Strideable
    struct ConformsToStrideable {
        @Test("Moves beat by an interval", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                22, BeatOf<Int>(.init(epoch: 34), timing: .init(carry: 1, coyote: 2))
            )
        ])
        func advanced(_ sut: Beat<Int, Int>, by n: Int, expected: Beat<Int, Int>) {
            let result = sut.advanced(by: n)
            #expect(result == expected)
        }

        @Test("Measures distance between beats", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 34), timing: .init(carry: 4, coyote: 5)),
                22
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 4, coyote: 5)),
                0
            )
        ])
        func distance(_ sut: Beat<Int, Int>, to other: Beat<Int, Int>, expected: Int) {
            let result = sut.distance(to: other)
            #expect(result == expected)
        }
    }

    // MARK: Self.Instant: Strideable
    struct InstantConformsToStrideable {
        @Test("Timing window for the beat", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                11...14
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: -4, coyote: 9)),
                16...21
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: -4, coyote: 2)),
                ClosedRange<Int>?.none
            )
        ])
        func window(_ sut: Beat<Int, Int>, expected: ClosedRange<Int>?) {
            let result = sut.window
            #expect(result == expected)
        }

        @Test("Can trigger beat at instant", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                12, true
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                14, true
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                11, true
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                6, false
            ),
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                20, false
            )
        ])
        func canTrigger(_ sut: Beat<Int, Int>, at instant: Int, expected: Bool) {
            let result = sut.canTrigger(at: instant)
            #expect(result == expected)
        }

        @Test("Indicates next beat", arguments: [
            (
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                Cooldown<Int>(22), BeatOf<Int>(.init(epoch: 34), timing: .init(carry: 1, coyote: 2))
            )
        ])
        func nextBeat(_ sut: Beat<Int, Int>, after cooldown: Cooldown<Int>, expected: Beat<Int, Int>) {
            let result = sut.nextBeat(after: cooldown)
            #expect(result == expected)
        }
    }

    // MARK: Sequence (EX)
    struct SequenceTests {
        @Test("Filters beat based on activation instant", arguments: [
            ([
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 18), timing: .init(carry: 4, coyote: 5))
            ], 12, [
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2))
            ]),
            ([
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 18), timing: .init(carry: 4, coyote: 5))
            ], 14, [
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 18), timing: .init(carry: 4, coyote: 5))
            ]),
            ([
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 18), timing: .init(carry: 4, coyote: 5))
            ], 20, [
                BeatOf<Int>(.init(epoch: 18), timing: .init(carry: 4, coyote: 5))
            ]),
            ([
                BeatOf<Int>(.init(epoch: 12), timing: .init(carry: 1, coyote: 2)),
                BeatOf<Int>(.init(epoch: 18), timing: .init(carry: 4, coyote: 5))
            ], 24, [Beat<Int, Int>]())
        ])
        func beats(_ sut: [Beat<Int, Int>], triggerableAt instant: Int, expected: [Beat<Int, Int>]) {
            let result = sut.beats(triggerableAt: instant)
            #expect(result == expected)
        }
    }
}
