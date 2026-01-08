//
//  Measured+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 02/09/25.
//

import Testing
@testable import TrinketsUnits

struct MeasuredTests {
    public typealias G = Unit<Gil>

    @Test("Allows using it using the following syntax")
    func propertyWrapper() {
        @Measured(in: .zeni) var money = 30
        #expect(money == UnitMeasure(10, .zeni))

        money += Gil.of(4, .linen)
        #expect(money == UnitMeasure(15, .zeni))
    }

    @Test("Initializes with wrapped value in unit", arguments: [
        (Gil.of(32, .linen), Gil.in(.linen), Gil.of(32, .linen)),
        (Gil.of(10, .zeni), Gil.in(.gil), Gil.of(30, .gil))
    ])
    func initializer(wrappedValue value: G.Measure, in unit: G, expected: G.Measure) {
        let result = Measured(wrappedValue: value, in: unit)
        #expect(result.measurement == expected)
        #expect(result.unit == unit)
    }

    @Test("Returns value of Measurement", arguments: [
        (Measured(wrappedValue: Gil.of(13, .gil), in: .gil), Gil.of(13, .gil)),
        (Measured(wrappedValue: Gil.of(13, .zeni), in: .linen), Gil.of(16, .linen))
    ])
    func wrappedValueGet(_ sut: Measured<G>, expected: G.Measure) {
        let result = sut.wrappedValue
        #expect(result == expected)
    }

    @Test("Converts given measure to the specified unit", arguments: [
        (
            Measured(wrappedValue: Gil.of(13, .gil), in: .gil),
            Gil.of(29, .gil),
            Measured(wrappedValue: Gil.of(29, .gil), in: .gil)
        ),
        (
            Measured(wrappedValue: Gil.of(2, .gil), in: .gil),
            Gil.of(13, .zeni),
            Measured(wrappedValue: Gil.of(39, .gil), in: .gil)
        )
    ])
    func wrappedValueSet(_ sut: Measured<G>, newValue: G.Measure, expected: Measured<G>) {
        var result = sut
        result.wrappedValue = newValue
        #expect(result == expected)
    }
}
