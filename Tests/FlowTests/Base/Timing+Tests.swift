//
//  Timing+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2026.
//

@testable import Flow
import Testing

struct TimingTests {
    @Test("Creates a new timing structure", arguments: [
        (9, 13)
    ])
    func initializer(carry: Int, coyote: Int) {
        let result = Timing(carry: carry, coyote: coyote)
        #expect(result.carry == carry)
        #expect(result.coyote == coyote)
    }

    @Test("Constants of timing", arguments: [
        (Timing<Int>.zero, Timing<Int>(carry: 0, coyote: 0))
    ])
    func constants(_ sut: Timing<Int>, expected: Timing<Int>) {
        #expect(sut == expected)
    }

    // MARK: Methods
    @Test("Calculates timing window for instant", arguments: [
        (Timing<Int>(carry: 5, coyote: 2), 12, 7...14),
        (Timing<Int>(carry: 0, coyote: 2), 12, 12...14),
        (Timing<Int>(carry: -3, coyote: 2), 12, ClosedRange<Int>?.none),
        (Timing<Int>(carry: 5, coyote: 0), 13, 8...13),
        (Timing<Int>(carry: 0, coyote: 0), 13, 13...13),
        (Timing<Int>(carry: -8, coyote: 0), 13, ClosedRange<Int>?.none),
        (Timing<Int>(carry: 10, coyote: -6), 14, 4...8),
        (Timing<Int>(carry: 0, coyote: -6), 14, ClosedRange<Int>?.none),
        (Timing<Int>(carry: -1, coyote: -6), 14, ClosedRange<Int>?.none)
    ])
    func window(_ sut: Timing<Int>, at instant: Int, expected: ClosedRange<Int>?) {
        let result = sut.window(at: instant)
        #expect(result == expected)
    }

    @Test("Calculates timing window for gamut", arguments: [
        (Timing<Int>(carry: 5, coyote: 2), 12...18, 7...20),
        (Timing<Int>(carry: 0, coyote: 2), 12...18, 12...20),
        (Timing<Int>(carry: -3, coyote: 2), 12...18, 15...20),
        (Timing<Int>(carry: 5, coyote: 0), 13...22, 8...22),
        (Timing<Int>(carry: 0, coyote: 0), 13...22, 13...22),
        (Timing<Int>(carry: -8, coyote: 0), 13...22, 21...22),
        (Timing<Int>(carry: 10, coyote: -6), 14...33, 4...27),
        (Timing<Int>(carry: 0, coyote: -6), 14...33, 14...27),
        (Timing<Int>(carry: -1, coyote: -36), 14...33, ClosedRange<Int>?.none)
    ])
    func window(_ sut: Timing<Int>, gamut: ClosedRange<Int>, expected: ClosedRange<Int>?) {
        let result = sut.window(gamut: gamut)
        #expect(result == expected)
    }
}
