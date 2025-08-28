//
//  Measurement+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2025.
//

import Testing
@testable import TrinketsUnits

struct MeasurementTests {
    @Test("Creates new measurement with unit and value", arguments: [
        (35, Gil.in(.zeni))
    ])
    func initializer(value: Int, unit: Unit<Gil>) {
        let result = Measurement(value: value, unit: unit)
        #expect(result.value == value)
        #expect(result.unit == unit)
    }

    // MARK: Self: Strideable
    struct Strideable {
        @Test("Returns raw magnitude of distance to other value", arguments: [
            (Gil.of(15, .zeni), Gil.of(36, .gil), -3)
        ])
        func distance(_ sut: Gil.Measure, to other: Gil.Measure, expected: Gil.Value) {
            let result = sut.distance(to: other)
            #expect(result == expected)
        }

        @Test("Adjusts measurement by a set amount", arguments: [
            (Gil.of(32, .linen), 10, Gil.of(42, .linen))
        ])
        func advanced(_ sut: Gil.Measure, by n: Gil.Value, expected: Gil.Measure) {
            let result = sut.advanced(by: n)
            #expect(result == expected)
        }
    }

    // MARK: D: Dimension, V: Dimension.Value
    struct DConformsToDimensionVIsDValue {
        @Test("Returns raw number representing the measurement", arguments: [
            (Gil.of(15, .zeni), 45),
            (Gil.of(9, .gil), 9),
            (Gil.of(4, .linen), 15)
        ])
        func baseValue(_ sut: Gil.Measure, expected: Gil.Value) {
            #expect(sut.baseValue == expected)
        }

        @Test("Creates a measurement in the base unit", arguments: [
            (Gil.of(15, .zeni), Measurement<Gil, Double>(value: 45, unit: .gil)),
            (Gil.of(9, .gil), Measurement<Gil, Double>(value: 9, unit: .gil)),
            (Gil.of(4, .linen), Measurement<Gil, Double>(value: 15, unit: .gil))
        ])
        func inBaseUnit(_ sut: Gil.Measure, expected: Gil.Measure) {
            #expect(sut.inBaseUnit == expected)
        }

        @Test("Converts a measurement to another unit", arguments: [
            (Gil.of(10, .linen), Gil.in(.zeni), Measurement<Gil, Double>(value: 9, unit: .zeni)),
            (Gil.of(9, .zeni), Gil.in(.linen), Measurement<Gil, Double>(value: 10, unit: .linen))
        ])
        func convert(_ sut: Gil.Measure, to otherUnit: Unit<Gil>, expected: Gil.Measure) {
            var methodA = sut
            methodA.convert(to: otherUnit)
            let methodB = sut.converted(to: otherUnit)

            #expect(methodA == expected)
            #expect(methodB == expected)
        }

        @Test("Returns value representation in another unit", arguments: [
            (Gil.of(21, .zeni), Gil.in(.linen), 28),
            (Gil.of(0, .linen), Gil.in(.gil), 7)
        ])
        func rawValue(_ sut: Gil.Measure, in otherUnit: Unit<Gil>, expected: Gil.Value) {
            let result = sut.rawValue(in: otherUnit)
            #expect(result == expected)
        }

        struct VConformsToAdditiveArithmetic {
            @Test("Returns a measure with value equal to zero")
            func zero() {
                let result = Measurement<Gil, Double>.zero
                #expect(result.unit == Gil.baseUnit)
                #expect(result.value == 0)
            }

            @Test("Adds two measurements together", arguments: [
                (Gil.of(14, .zeni), Gil.of(1, .linen), Gil.of(17, .zeni)),
                (Gil.of(20, .gil), Gil.of(8, .zeni), Gil.of(44, .gil))
            ])
            func plus(lhs: Gil.Measure, rhs: Gil.Measure, expected: Gil.Measure) {
                let result = lhs + rhs
                #expect(result == expected)
            }

            @Test("Removes a measurement from another", arguments: [
                (Gil.of(14, .zeni), Gil.of(1, .linen), Gil.of(11, .zeni)),
                (Gil.of(20, .gil), Gil.of(5, .zeni), Gil.of(5, .gil))
            ])
            func minus(lhs: Gil.Measure, rhs: Gil.Measure, expected: Gil.Measure) {
                let result = lhs - rhs
                #expect(result == expected)
            }
        }

        struct VConformsToComparable {
            @Test("Compares two measurements using their base value", arguments: [
                (Gil.of(10, .zeni), Gil.of(7, .gil), false),
                (Gil.of(15, .linen), Gil.of(13, .zeni), true),
                (Gil.of(9, .gil), Gil.of(3, .zeni), false),
                (Gil.of(10, .gil), Gil.of(2, .linen), true)
            ])
            func lesserThan(lhs: Gil.Measure, rhs: Gil.Measure, expected: Bool) {
                let result = lhs < rhs
                #expect(result == expected)
            }
        }
    }

    // MARK: V: AdditiveArithmetic
    struct VConformsToAdditiveArithmetic {
        @Test("Adds value in the current unit", arguments: [
            (Gil.of(23, .linen), 7, Gil.of(30, .linen))
        ])
        func plus(lhs: Gil.Measure, rhs: Gil.Value, expected: Gil.Measure) {
            let result = lhs + rhs
            #expect(result == expected)
        }

        @Test("Removes value in the current unit", arguments: [
            (Gil.of(12, .zeni), 3, Gil.of(9, .zeni))
        ])
        func minus(lhs: Gil.Measure, rhs: Gil.Value, expected: Gil.Measure) {
            let result = lhs - rhs
            #expect(result == expected)
        }
    }

    // MARK: V: Numeric
    struct VConformsToNumeric {
        @Test("Multiplies value with measurement", arguments: [
            (Gil.of(23, .gil), 3, Gil.of(69, .gil))
        ])
        func multiply(lhs: Gil.Measure, rhs: Gil.Value, expected: Gil.Measure) {
            let result = lhs * rhs
            #expect(result == expected)
        }
    }
}
