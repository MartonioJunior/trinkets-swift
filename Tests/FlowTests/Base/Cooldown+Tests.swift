//
//  Cooldown+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

@testable import Flow
import Testing

struct CooldownTests {
    // MARK: Methods
    @Test("Calculates recovery instant", arguments: [
        (Cooldown<Int>(4), 12, 16),
        (Cooldown<Int>(0), 13, 13),
        (Cooldown<Int>(-5), 14, 9)
    ])
    func recovery(_ sut: Cooldown<Int>, after activation: Int, expected: Int) {
        let result = sut.recovery(after: activation)
        #expect(result == expected)
    }

    @Test("Calculates cooldown window", arguments: [
        (Cooldown<Int>(4), 12, 16...),
        (Cooldown<Int>(0), 13, 13...),
        (Cooldown<Int>(-5), 14, 9...)
    ])
    func window(_ sut: Cooldown<Int>, after activation: Int, expected: PartialRangeFrom<Int>) {
        let result = sut.window(after: activation)
        #expect(result.lowerBound == expected.lowerBound)
    }
}
