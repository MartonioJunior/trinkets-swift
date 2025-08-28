//
//  Measurement.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

public struct Measurement<D: Domain, V> {
    // MARK: Variables
    public var value: V
    public let unit: Unit<D>

    // MARK: Initializers
    public init(value: V, unit: Unit<D>) {
        self.value = value
        self.unit = unit
    }
}

// MARK: Self: Equatable
extension Measurement: Equatable where D.Features: Equatable, V: Equatable {}

// MARK: Self: Sendable
extension Measurement: Sendable where D.Features: Sendable, V: Sendable {}

// MARK: Self: Strideable
extension Measurement: Strideable where Self: Comparable, V: SignedNumeric {
    public func distance(to other: Measurement<D, V>) -> V {
        other.rawValue(in: unit) - value
    }

    public func advanced(by n: V) -> Measurement<D, V> {
        .init(value: value + n, unit: unit)
    }
}

// MARK: V: AdditiveArithmetic
public extension Measurement where V: AdditiveArithmetic {
    static func + (lhs: Self, rhs: V) -> Self {
        .init(value: lhs.value + rhs, unit: lhs.unit)
    }

    static func - (lhs: Self, rhs: V) -> Self {
        .init(value: lhs.value - rhs, unit: lhs.unit)
    }
}

// MARK: V: Numeric
public extension Measurement where V: Numeric {
    static func * (lhs: Self, rhs: V) -> Self {
        .init(value: lhs.value * rhs, unit: lhs.unit)
    }
}
