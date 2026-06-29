//
//  Measurement+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2025.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct MeasurementTests {
    // MARK: Initializers
    @Test("Creates new measurement with dynamic unit and value", arguments: [
        (35, RPGMoney.Constant(value: 8))
    ])
    func initializer(_ value: Double, _ unit: RPGMoney.Constant) {
        let result = Measurement(value, unit)
        #expect(result.value == value)
        #expect(result.unit == unit)
    }

    // MARK: Methods
    @Test("Maps the value to a new amount", arguments: [
        (Measurement(23, RPGMoney.Constant(value: 6)), Measurement(46, RPGMoney.Constant(value: 6)))
    ])
    func mapValue(_ sut: Measurement<RPGMoney.Constant, Double>, expected: Measurement<RPGMoney.Constant, Double>) {
        let result = sut.mapValue { $0 * 2 }
        #expect(result.unit == expected.unit)
        #expect(result.value == expected.value)
    }

    // MARK: Self.Value: AdditiveArithmetic
    struct ValueConformsToAdditiveArithmetic {
        @Test("Returns measurement with 0 value", arguments: [
            (RefreshRate.FPS(refreshRate: 22), Measurement(0, RefreshRate.FPS(refreshRate: 22)))
        ])
        func zero(_ unit: RefreshRate.FPS, expected: Measurement<RefreshRate.FPS, Double>) {
            let result = Measurement.zero(unit, valueType: Double.self)
            #expect(result == expected)
        }

        @Test("Sums measurement with value", arguments: [
            (
                Measurement(15, RPGMoney.Constant(value: 4)), 8,
                Measurement(23, RPGMoney.Constant(value: 4))
            )
        ])
        func plusDynamic(
            lhs: Measurement<RPGMoney.Constant, Double>,
            rhs: Double, 
            expected: Measurement<RPGMoney.Constant, Double>
        ) {
            let result = lhs + rhs
            #expect(result == expected)
        }

        @Test("Subtracts value from measurements", arguments: [
            (
                Measurement(15, RPGMoney.Constant(value: 4)), 8,
                Measurement(7, RPGMoney.Constant(value: 4))
            )
        ])
        func minusDynamic(lhs: Measurement<RPGMoney.Constant, Double>, rhs: Double, expected: Measurement<RPGMoney.Constant, Double>) {
            let result = lhs - rhs
            #expect(result == expected)
        }
    }
}

extension MeasurementTests {
    // MARK: Self.Value == Bool
    struct ValueIsBool {
        @Test("Toggles the value of the measurement", arguments: [
            (
                Measurement(true, RefreshRate.FPS(refreshRate: 12)),
                Measurement(false, RefreshRate.FPS(refreshRate: 12))
            ),
            (
                Measurement(false, RefreshRate.FPS(refreshRate: 23)),
                Measurement(true, RefreshRate.FPS(refreshRate: 23))
            )
        ])
        func negated(
            _ sut: Measurement<RefreshRate.FPS, Bool>,
            expected: Measurement<RefreshRate.FPS, Bool>
        ) {
            let resultA = sut.toggled()
            let resultB = !sut

            #expect(resultA == expected)
            #expect(resultB == expected)
        }
    }

    // MARK: Value: FloatingPoint
    struct ValueConformsToFloatingPoint {
        @Test("Divides measurement by value", arguments: [
            (Measurement(24, RPGMoney.Constant(value: 8)), 3, Measurement(8, RPGMoney.Constant(value: 8))),
            (Measurement(11, RPGMoney.Constant(value: 12)), 4, Measurement(2.75, RPGMoney.Constant(value: 12)))
        ])
        func divideDynamic(
            lhs: Measurement<RPGMoney.Constant, Double>,
            rhs: Double,
            expected: Measurement<RPGMoney.Constant, Double>
        ) {
            let result = lhs / rhs
            #expect(result == expected)
        }
    }

    // MARK: Value: Numeric
    struct ValueConformsToNumeric {
        @Test("Multiplies measurement by value", arguments: [
            (Measurement(24, RPGMoney.Constant(value: 8)), 3, Measurement(72, RPGMoney.Constant(value: 8))),
            (Measurement(11, RPGMoney.Constant(value: 12)), 0.5, Measurement(5.5, RPGMoney.Constant(value: 12)))
        ])
        func multiplyDynamic(
            lhs: Measurement<RPGMoney.Constant, Double>,
            rhs: Double,
            expected: Measurement<RPGMoney.Constant, Double>
        ) {
            let result = lhs * rhs
            #expect(result == expected)
        }
    }

    // MARK: Value: SignedNumeric
    struct ValueConformsToSignedNumeric {
        @Test("Negates a measurement's value", arguments: [
            (Measurement(24, RPGMoney.Constant(value: 8)), Measurement(-24, RPGMoney.Constant(value: 8)))
        ])
        func negate(_ sut: Measurement<RPGMoney.Constant, Double>, expected: Measurement<RPGMoney.Constant, Double>) {
            let result = -sut
            #expect(result == expected)
        }
    }
}
