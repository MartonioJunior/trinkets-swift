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

// MARK: Self: AdditiveArithmetic
extension Measurement: AdditiveArithmetic where D: Dimension, D.Features: Equatable, D.Symbol: Equatable, V == D.Value, V: AdditiveArithmetic {}

// MARK: Self: Comparable
extension Measurement: Comparable where D: Dimension, D.Features: Equatable, D.Symbol: Equatable, V == D.Value, V: Comparable {}

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

// MARK: D: Dimension, V == D.Value
public extension Measurement where D: Dimension, V == D.Value {
    var baseValue: V { D.baseValue(of: value, unit) }
    var inBaseUnit: Self { .init(value: baseValue, unit: .default) }

    mutating func convert(to otherUnit: Unit<D>) {
        self = converted(to: otherUnit)
    }

    func converted(to otherUnit: Unit<D>) -> Self {
        let valueInOtherUnit = D.convert(baseValue, to: otherUnit)
        return .init(value: valueInOtherUnit, unit: otherUnit)
    }

    func rawValue(in otherUnit: Unit<D>) -> V {
        converted(to: otherUnit).value
    }
}

public extension Measurement where D: Dimension, V == D.Value, V: AdditiveArithmetic {
    static var zero: Measurement<D, V> { .init(value: .zero, unit: .default) }

    static func + (lhs: Self, rhs: Self) -> Self {
        let baseUnit = lhs.unit
        let rhsValue = rhs.rawValue(in: baseUnit)

        return .init(value: lhs.value + rhsValue, unit: baseUnit)
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        let baseUnit = lhs.unit
        let rhsValue = rhs.rawValue(in: baseUnit)

        return .init(value: lhs.value - rhsValue, unit: baseUnit)
    }
}

public extension Measurement where D: Dimension, V == D.Value, V: Comparable {
    static func < (lhs: Measurement<D, V>, rhs: Measurement<D, V>) -> Bool {
        lhs.baseValue < rhs.baseValue
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
