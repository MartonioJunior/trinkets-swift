//
//  Measurement.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

/// Data structure representing a quantified measure in a given unit.
/// 
/// - UnitType: Domain where this measure exists.
/// - Value: Type representing the quantity associated with the measure.
public struct Measurement<UnitType, Value> {
    // MARK: Variables
    /// Quantity measured.
    public var value: Value
    /// Unit for this measure.
    public let unit: UnitType

    // MARK: Initializers
    private init(value: Value, unit: UnitType) {
        self.value = value
        self.unit = unit
    }
    /// Creates a new measurement for a dynamic unit.
    /// - Parameters:
    ///   - value: Quantity associated with the unit.
    ///   - unit: Unit that defines the measure.
    ///
    public init(_ value: Value, _ unit: UnitType) where UnitType: Quantifiable {
        self.init(value: value, unit: unit)
    }
    /// Creates a new measurement for a static unit.
    /// - Parameters:
    ///   - value: Quantity associated with the unit.
    ///   - type: Unit that defines the measure.
    ///
    public init<S: StaticUnit>(_ value: Value, _ type: S.Type = S.self) where UnitType == S.Type {
        self.init(value: value, unit: type)
    }
    // MARK: Methods
    /// Maps a measurement by it's value.
    /// - Parameter transform: Transformation function for the value.
    /// - Returns: A new measurement with the transformed value in the same unit.
    public func mapValue<T>(_ transform: (Value) -> T) -> Measurement<UnitType, T> {
        .init(value: transform(value), unit: unit)
    }
}

// MARK: Self: Equatable
extension Measurement: Equatable where UnitType: Equatable, Value: Equatable {}

// MARK: Self: Formattable
extension Measurement: Formattable {}

// MARK: Self: Hashable
extension Measurement: Hashable where UnitType: Hashable, Value: Hashable {}

// MARK: Self: Measurable
extension Measurement: Measurable where UnitType: Quantifiable {
    // swiftlint:disable:next missing_docs
    public typealias Unit = UnitType
    // swiftlint:disable:next missing_docs
    public typealias Quantity = Value
    // swiftlint:disable:next missing_docs
    public var quantity: Value { value }
}

// MARK: Self: Sendable
extension Measurement: Sendable where UnitType: Sendable, Value: Sendable {}

// MARK: Self.Value: AdditiveArithmetic
public extension Measurement where Value: AdditiveArithmetic {
    /// Creates a new zero measurement in a given unit.
    /// - Parameters:
    ///   - unit: Unit associated with the measure.
    ///
    /// - Returns: A new measurement.
    static func zero(
        _ unit: UnitType,
        valueType _: Value.Type = Value.self
    ) -> Self where UnitType: Quantifiable {
        .init(.zero, unit)
    }
    /// Adds a value to the measure.
    /// 
    /// Assumes that the value is in the same unit as the measure itself.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Quantity to add.
    ///
    /// - Returns: A new measurement with the sum of quantities.
    static func + (lhs: Self, rhs: Value) -> Self {
        .init(value: lhs.value + rhs, unit: lhs.unit)
    }
    /// Adds a measure to another.
    /// 
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Another measurement.
    ///
    /// - Returns: A new measurement with the sum of quantities.
    static func + <S: StaticUnit>(lhs: Self, rhs: Self) -> Self where UnitType == S.Type {
        .init(lhs.value + rhs.value, lhs.unit)
    }
    /// Subtracts a value from the measure.
    /// 
    /// Assumes that the value is in the same unit as the measure itself.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Quantity to subtract.
    ///
    /// - Returns: A new measurement with the difference of quantities.
    static func - (lhs: Self, rhs: Value) -> Self {
        .init(value: lhs.value - rhs, unit: lhs.unit)
    }
    /// Subtracts a measure from another.
    /// 
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Another measurement.
    ///
    /// - Returns: A new measurement with the difference of quantities.
    static func - <S: StaticUnit>(lhs: Self, rhs: Self) -> Self where UnitType == S.Type {
        .init(lhs.value - rhs.value, lhs.unit)
    }
}

// MARK: Self.Value == Bool
public extension Measurement where Value == Bool {
    /// Inverts the registered value for the unit.
    /// - Returns: A measurement with a toggled value.
    func toggled() -> Self { .init(value: !value, unit: unit) }
    /// Inverts the registered value for the unit.
    /// - Parameter rhs: A measurement.
    /// - Returns: A measurement with a toggled value.
    static prefix func ! (rhs: Self) -> Self { rhs.toggled() }
}

// MARK: Self.Value: Comparable
public extension Measurement where Value: Comparable {
    /// Compares two measurements against each other
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Another measurement
    ///
    /// - Returns: `true` when the quantity in the left-side is lesser than on the right-side, `false` otherwise.
    static func < <S: StaticUnit>(lhs: Self, rhs: Self) -> Bool where UnitType == S.Type {
        lhs.value < rhs.value
    }
}

// MARK: Self.Value: FloatingPoint
public extension Measurement where Value: FloatingPoint {
    /// Divides a measure by another.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Another measurement.
    ///
    /// - Returns: A new measurement that divides the numerator value by the denominator.
    static func / <S: StaticUnit>(lhs: Self, rhs: Self) -> Self where UnitType == S.Type {
        .init(lhs.value / rhs.value, lhs.unit)
    }
    /// Divides a measure by a quantity.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Quantity to use.
    ///
    /// - Returns: A new measurement where the value is divided by the quantity.
    static func / (lhs: Self, rhs: Value) -> Self {
        .init(value: lhs.value / rhs, unit: lhs.unit)
    }
}

// MARK: Self.Value: Numeric
public extension Measurement where Value: Numeric {
    /// Multiplies a measure by another.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Another measurement.
    ///
    /// - Returns: A new measurement that multiplies the values of both measurements together.
    static func * <S: StaticUnit>(lhs: Self, rhs: Self) -> Self where UnitType == S.Type {
        .init(lhs.value * rhs.value, lhs.unit)
    }
    /// Multiplies a measure by a quantity.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Quantity.
    ///
    /// - Returns: A new measurement where the value is divided by the quantity.
    static func * (lhs: Self, rhs: Value) -> Self {
        .init(value: lhs.value * rhs, unit: lhs.unit)
    }
}

// MARK: Self.Value: SignedNumeric
extension Measurement where Value: SignedNumeric {
    /// Negates the value in the measurement.
    /// - Parameter rhs: A measurement
    /// - Returns: A new measurement with the negated value.
    static prefix func - (rhs: Self) -> Self {
        .init(value: -rhs.value, unit: rhs.unit)
    }
}
