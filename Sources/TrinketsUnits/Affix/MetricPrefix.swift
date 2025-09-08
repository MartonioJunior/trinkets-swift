//
//  MetricPrefix.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/06/25.
//

public struct MetricPrefix {
    // MARK: Variables
    let multiplier: Double
    let symbol: String

    // MARK: Initializers
    public init(symbol: String, _ base: Double = 10, e exponent: Int) {
        self.symbol = symbol
        self.multiplier = loopPow(base, e: exponent)
    }
}

// MARK: Self: Codable
extension MetricPrefix: Codable {}

// MARK: Self: Comparable
extension MetricPrefix: Comparable {
    public static func < (lhs: MetricPrefix, rhs: MetricPrefix) -> Bool {
        lhs.multiplier < rhs.multiplier
    }
}

// MARK: Self: Equatable
extension MetricPrefix: Equatable {}

// MARK: Self: Hashable
extension MetricPrefix: Hashable {}

// MARK: Self: Sendable
extension MetricPrefix: Sendable {}

// MARK: Dimension (EX)
public extension Dimension where Features == LinearConverter {
    static func `in`(_ scale: MetricPrefix, _ unit: Unit) -> Unit {
        .init(scale, unit)
    }
}

// MARK: Unit (EX)
public extension Unit where D.Features == LinearConverter {
    init(_ scale: MetricPrefix, _ unit: Self) {
        self.init("\(scale.symbol)\(unit.symbol)", details: unit.features * scale.multiplier)
    }
}
