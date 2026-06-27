//
//  Measured.swift
//  Trinkets
//
//  Created by Martônio Júnior on 02/09/2025.
//

import Tagged

/// Property wrapper that defines a value as a dynamic measure.
/// - UnitType: Type representing the target unit associated to the quantity.
/// - Value: Type representing the quantity defined.
/// 
/// Example:
/// ```swift
/// @Measured(in: .kilometers) var distance = 35 // 35 kilometers
/// ```
@propertyWrapper
public struct Measured<UnitType: Convertible, Value> {
    // MARK: Variables
    /// Internal wrapped measurement.
    var measurement: Measurement<UnitType, Value>
    /// Converter from current unit towards base value.
    var base: @Sendable (Measurement<UnitType, Value>) -> Tagged<UnitType.Base, Value>
    /// Converter from base value to a given unit.
    var converter: @Sendable (Tagged<UnitType.Base, Value>) -> Measurement<UnitType, Value>
    /// Returns the wrapped measurement in a given unit.
    public var wrappedValue: Measurement<UnitType, Value> {
        get { measurement }
        set { setValue(newValue) }
    }
    // MARK: Initializers
    /// Creates a new `@Measured` instance for a given unit.
    /// - Parameters:
    ///   - value: Quantity in the given unit.
    ///   - unit: Unit of reference.
    ///   - base: Converter used to obtain the base value.
    ///   - converter: Converter used to derive quantity from the base value.
    ///
    public init(
        wrappedValue value: Value,
        in unit: UnitType,
        _ base: @escaping @Sendable (Measurement<UnitType, Value>) -> Tagged<UnitType.Base, Value>,
        _ converter: @escaping @Sendable (Tagged<UnitType.Base, Value>) -> Measurement<UnitType, Value>
    ) where UnitType: Sendable {
        self.measurement = Measurement(value, unit)
        self.base = base
        self.converter = converter
    }
    // MARK: Methods
    /// Sets the value to be the same as another measurement.
    /// - Parameter newValue: Measurement.
    public mutating func setValue(
        _ newValue: Measurement<UnitType, Value>
    ) where UnitType: Convertible {
        measurement = converter(base(newValue))
    }
    /// Sets the value to be the same as a tagged measure.
    /// - Parameters:
    ///   - tagged: Tagged measure.
    public mutating func setValue<T: Domain>(
        _ tagged: Tagged<T, Value>
    ) where UnitType.Base == T {
        measurement = converter(tagged)
    }
}

// MARK: Self: Equatable
extension Measured: Equatable where UnitType: Equatable, Value: Equatable {
    // swiftlint:disable:next missing_docs
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.measurement == rhs.measurement
    }
}

// MARK: Self: Sendable
extension Measured: Sendable where UnitType: Sendable, Value: Sendable {}
