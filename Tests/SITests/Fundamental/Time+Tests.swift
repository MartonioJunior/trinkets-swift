//
//  Time+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2025.
//

@testable import SI
import Testing
import TrinketsUnits

struct TimeTests {
    @Test("Converts a Duration instance into a Measure", arguments: [
        (Duration(secondsComponent: 350, attosecondsComponent: 0), Time.of(350, .seconds)),
        (Duration(secondsComponent: 8, attosecondsComponent: 895_000_000_000_000_000), Time.of(8.895, .seconds))
    ])
    func initializer(_ duration: Duration, expected: Time.Measure) {
        let result = Measurement(duration)
        #expect(result == expected)
    }

    @Test("Returns the equivalent Duration instance", arguments: [
        (Time.of(5, .minutes), Duration(secondsComponent: 300, attosecondsComponent: 0)),
        (Time.of(1.6, .seconds), Duration(secondsComponent: 1, attosecondsComponent: 600_000_000_000_000_128))
    ])
    func asDuration(_ sut: Time.Measure, expected: Duration) {
        let result = sut.asDuration
        #expect(result == expected)
    }
}
