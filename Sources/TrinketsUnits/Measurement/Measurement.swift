//
//  Measurement.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

// MARK: Aliases
public typealias UnitMeasure<D: Dimension> = Measurement<Unit<D>>

public struct Measurement<UnitType: Measurable> {
    public typealias Value = UnitType.Value

    // MARK: Variables
    public var value: Value
    public let unit: UnitType

    // MARK: Initializers
    public init(_ value: Value, _ unit: UnitType) {
        self.value = value
        self.unit = unit
    }
}

// MARK: Self: AdditiveArithmetic
extension Measurement: AdditiveArithmetic where UnitType: Convertible & Equatable, Value: AdditiveArithmetic {
    public static var zero: Self { .init(.zero, .base) }

    public static func + (lhs: Self, rhs: Self) -> Self {
        let baseUnit = lhs.unit
        let rhsValue = rhs.rawValue(in: baseUnit)

        return .init(lhs.value + rhsValue, baseUnit)
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        let baseUnit = lhs.unit
        let rhsValue = rhs.rawValue(in: baseUnit)

        return .init(lhs.value - rhsValue, baseUnit)
    }
}

// MARK: Self: Comparable
extension Measurement: Comparable where UnitType: Convertible & Equatable, Value: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.baseValue < rhs.baseValue
    }
}

// MARK: Self: Equatable
extension Measurement: Equatable where UnitType: Equatable, Value: Equatable {}

// MARK: Self: ExpressibleByFloatLiteral
extension Measurement: ExpressibleByFloatLiteral where UnitType: Convertible, Value: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(Value(floatLiteral: value), .base)
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Measurement: ExpressibleByIntegerLiteral where UnitType: Convertible, Value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(Value(integerLiteral: value), .base)
    }
}

// MARK: Self: Hashable
extension Measurement: Hashable where UnitType: Hashable, Value: Hashable {}

// MARK: Self: Sendable
extension Measurement: Sendable where UnitType: Sendable, Value: Sendable {}

// MARK: Self: Strideable
extension Measurement: Strideable where Self: Comparable, Value: SignedNumeric {
    public func distance(to other: Self) -> Value {
        other.rawValue(in: unit) - value
    }

    public func advanced(by n: Value) -> Self {
        .init(value + n, unit)
    }
}

// MARK: UnitType: Convertible
public extension Measurement where UnitType: Convertible {
    var baseValue: Value { UnitType.baseValue(of: value, unit) }

    mutating func convert(to otherUnit: UnitType) {
        self = converted(to: otherUnit)
    }

    func converted(to otherUnit: UnitType) -> Self {
        let valueInOtherUnit = UnitType.convert(baseValue, to: otherUnit)
        return .init(valueInOtherUnit, otherUnit)
    }

    func rawValue(in otherUnit: UnitType) -> Value {
        converted(to: otherUnit).value
    }
}

// MARK: UnitType: Dimension
public extension Measurement {
    func inBaseUnit<D: Dimension>() -> Self where UnitType == Unit<D> {
        .init(D.baseValue(of: value, unit), D.baseUnit)
    }
}

// MARK: Value: AdditiveArithmetic
public extension Measurement where Value: AdditiveArithmetic {
    static func + (lhs: Self, rhs: Value) -> Self {
        .init(lhs.value + rhs, lhs.unit)
    }

    static func - (lhs: Self, rhs: Value) -> Self {
        .init(lhs.value - rhs, lhs.unit)
    }
}

// MARK: Value == Bool
public extension Measurement where Value == Bool {
    func negated() -> Self { .init(!value, unit) }

    static prefix func ! (rhs: Self) -> Self { rhs.negated() }
}

// MARK: Value: FloatingPoint
public extension Measurement where Value: FloatingPoint {
    static func / (lhs: Self, rhs: Value) -> Self {
        .init(lhs.value / rhs, lhs.unit)
    }
}

// MARK: Value: Numeric
public extension Measurement where Value: Numeric {
    static func * (lhs: Self, rhs: Value) -> Self {
        .init(lhs.value * rhs, lhs.unit)
    }
}

// MARK: Value: SignedNumeric
extension Measurement where Value: SignedNumeric {
    static prefix func - (rhs: Self) -> Self {
        .init(-rhs.value, rhs.unit)
    }
}
