//
//  Time+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2025.
//

@testable import SI
import Tagged
import Testing
import TrinketsUnits

struct TimeTests {
    @Test("Converts a Duration instance into a Measure", arguments: [
        (Duration(secondsComponent: 350, attosecondsComponent: 0), Tagged<Time, Double>(350)),
        (Duration(secondsComponent: 8, attosecondsComponent: 895_000_000_000_000_000), Tagged<Time, Double>(8.895))
    ])
    func initializer(_ duration: Duration, expected: Tagged<Time, Double>) {
        let result = Tagged(duration)
        #expect(result == expected)
    }

    @Test("Returns the equivalent Duration instance", arguments: [
        (Tagged<Time, Double>(300), Duration(secondsComponent: 300, attosecondsComponent: 0)),
        (Tagged<Time, Double>(1.600_000_000_000_000_128), Duration(secondsComponent: 1, attosecondsComponent: 600_000_000_000_000_128))
    ])
    func asDuration(_ sut: Tagged<Time, Double>, expected: Duration) {
        let result = sut.asDuration
        #expect(result == expected)
    }
}
