//
//  Timing+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2026.
//

@testable import Flow
import Testing

struct TimingTests {
    // @Test("Creates a new timing structure", arguments: [
    //     (9, 6, 13)
    // ])
    // func initializer(carry: Int, cooldown: Int, coyote: Int) {
    //     let result = Timing(carry: carry, coyote: coyote, cooldown: cooldown)
    //     #expect(result.carry == carry)
    //     #expect(result.cooldown == cooldown)
    //     #expect(result.coyote == coyote)
    // }

    // @Test("Constants of timing", arguments: [
    //     (Timing<Int>.zero, Timing<Int>(carry: 0, coyote: 0, cooldown: 0))
    // ])
    // func constants(_ sut: Timing<Int>, expected: Timing<Int>) {
    //     #expect(sut == expected)
    // }

    // // MARK: Methods
    // @Test("Calculates cooldown window", arguments: [
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: 4), 12, 16...),
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: 0), 13, 13...),
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: -5), 14, 11...)
    // ])
    // func cooldown(_ sut: Timing<Int>, after activation: Int, expected: PartialRangeFrom<Int>) {
    //     let resultA = sut.cooldown(after: activation)
    //     #expect(resultA.lowerBound == expected.lowerBound)

    //     let resultB = sut.cooldown(after: activation) { $0.advanced(by: $1) }
    //     #expect(resultB.lowerBound == expected.lowerBound)
    // }

    // @Test("Calculates expiration instant", arguments: [
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: 4), 12, 14),
    //     (Timing<Int>(carry: 5, coyote: 0, cooldown: 4), 13, 13),
    //     (Timing<Int>(carry: 5, coyote: -6, cooldown: 4), 14, 8)
    // ])
    // func expiration(_ sut: Timing<Int>, startingFrom instant: Int, expected: Int) {
    //     let resultA = sut.expiration(startingFrom: instant)
    //     #expect(resultA == expected)

    //     let resultB = sut.expiration(startingFrom: instant) { $0.advanced(by: $1) }
    //     #expect(resultB == expected)
    // }

    // @Test("Calculates recovery instant", arguments: [
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: 4), 12, 16),
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: 0), 13, 13),
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: -5), 14, 11)
    // ])
    // func recovery(_ sut: Timing<Int>, after activation: Int, expected: Int) {
    //     let resultA = sut.recovery(after: activation)
    //     #expect(resultA == expected)

    //     let resultB = sut.recovery(after: activation) { $0.advanced(by: $1) }
    //     #expect(resultB == expected)
    // }

    // @Test("Calculates Quick-Time Event Window", arguments: [
    //     (Timing<Int>(carry: 5, coyote: 2, cooldown: 4), 12, ...14),
    //     (Timing<Int>(carry: 5, coyote: 0, cooldown: 4), 13, ...13),
    //     (Timing<Int>(carry: 5, coyote: -6, cooldown: 4), 14, ...8)
    // ])
    // func quickTimeEvent(_ sut: Timing<Int>, startingFrom instant: Int, expected: PartialRangeThrough<Int>) {
    //     let resultA = sut.quickTimeEvent(startingFrom: instant)
    //     #expect(resultA.upperBound == expected.upperBound)

    //     let resultB = sut.quickTimeEvent(startingFrom: instant) { $0.advanced(by: $1) }
    //     #expect(resultB.upperBound == expected.upperBound)
    // }

    @Test("Calculates timing window for instant", arguments: [
        (Timing<Int>(carry: 5, coyote: 2, cooldown: 4), 12, 7...14),
        (Timing<Int>(carry: 0, coyote: 2, cooldown: 4), 12, 12...14),
        (Timing<Int>(carry: -3, coyote: 2, cooldown: 4), 12, ClosedRange<Int>?.none),
        (Timing<Int>(carry: 5, coyote: 0, cooldown: 4), 13, 8...13),
        (Timing<Int>(carry: 0, coyote: 0, cooldown: 4), 13, 13...13),
        (Timing<Int>(carry: -8, coyote: 0, cooldown: 4), 13, ClosedRange<Int>?.none),
        (Timing<Int>(carry: 10, coyote: -6, cooldown: 4), 14, 4...8),
        (Timing<Int>(carry: 0, coyote: -6, cooldown: 4), 14, ClosedRange<Int>?.none),
        (Timing<Int>(carry: -1, coyote: -6, cooldown: 4), 14, ClosedRange<Int>?.none)
    ])
    func window(_ sut: Timing<Int>, at instant: Int, expected: ClosedRange<Int>?) {
        let resultA = sut.window(at: instant)
        #expect(resultA == expected)

        // let resultB = sut.window(at: instant) { $0.advanced(by: $1) }
        // #expect(resultB == expected)
    }

    @Test("Calculates timing window for gamut", arguments: [
        (Timing<Int>(carry: 5, coyote: 2, cooldown: 4), 12...18, 7...20),
        (Timing<Int>(carry: 0, coyote: 2, cooldown: 4), 12...18, 12...20),
        (Timing<Int>(carry: -3, coyote: 2, cooldown: 4), 12...18, 15...20),
        (Timing<Int>(carry: 5, coyote: 0, cooldown: 4), 13...22, 8...22),
        (Timing<Int>(carry: 0, coyote: 0, cooldown: 4), 13...22, 13...22),
        (Timing<Int>(carry: -8, coyote: 0, cooldown: 4), 13...22, 21...22),
        (Timing<Int>(carry: 10, coyote: -6, cooldown: 4), 14...33, 4...27),
        (Timing<Int>(carry: 0, coyote: -6, cooldown: 4), 14...33, 14...27),
        (Timing<Int>(carry: -1, coyote: -36, cooldown: 4), 14...33, ClosedRange<Int>?.none)
    ])
    func window(_ sut: Timing<Int>, gamut: ClosedRange<Int>, expected: ClosedRange<Int>?) {
        let result = sut.window(gamut: gamut)
        #expect(result == expected)
    }
}
