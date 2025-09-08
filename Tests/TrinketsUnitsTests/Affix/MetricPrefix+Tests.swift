//
//  MetricPrefix+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2025.
//

import Testing
@testable import TrinketsUnits

struct MetricPrefixTests {
    @Test("Creates new metric prefix with symbol", arguments: [
        ("p", 10, 3, 1000),
        ("s", 2, 3, 8),
    ])
    func initializer(symbol: String, _ base: Double, e exponent: Int, expected: Double) {
        let result = MetricPrefix(symbol: symbol, base, e: exponent)
        #expect(result.multiplier == expected)
        #expect(result.symbol == symbol)
    }

    // MARK: Self: Comparable
    struct ConformsToComparable {
        @Test("Compares multipliers with no participation of symbol", arguments: [
            (MetricPrefix.tubular, MetricPrefix.whoa, true),
            (MetricPrefix.whoa, MetricPrefix.tubular, false),
            (MetricPrefix.whoa, MetricPrefix.whoa, false)
        ])
        func lesserThan(lhs: MetricPrefix, rhs: MetricPrefix, expected: Bool) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }
}

// MARK: Dimension (EX)
extension DimensionTests {
    @Test("Creates new unit by composing prefix + unit", arguments: [
        (MetricPrefix.tubular, Mock.Unit.base, Unit<Mock>("hiHIg", details: LinearConverter(16))),
        (MetricPrefix.whoa, Mock.in(.zeni), Unit<Mock>("öz", details: LinearConverter(300_000_000_000))),
        (MetricPrefix.tubular, Mock.in(.linen), Unit<Mock>("hiHIln", details: LinearConverter(32, k: 112))),
    ])
    func `in`(_ scale: MetricPrefix, _ unit: Mock.Unit, expected: Mock.Unit) {
        let result = Mock.in(scale, unit)
        #expect(result == expected)
    }
}

// MARK: Unit (EX)
extension UnitTests {
    @Test("Creates new unit by composing prefix + unit", arguments: [
        (MetricPrefix.tubular, Gil.Unit.base, Unit<Gil>("hiHIg", details: LinearConverter(16))),
        (MetricPrefix.whoa, Gil.in(.zeni), Unit<Gil>("öz", details: LinearConverter(300_000_000_000))),
        (MetricPrefix.tubular, Gil.in(.linen), Unit<Gil>("hiHIln", details: LinearConverter(32, k: 112)))
    ])
    func initializer(_ scale: MetricPrefix, _ unit: Gil.Unit, expected: Gil.Unit) {
        let result = Unit(scale, unit)
        #expect(result == expected)
    }
}
