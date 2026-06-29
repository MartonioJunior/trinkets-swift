//
//  Measured.swift
//  Trinkets
//
//  Created by Martônio Júnior on 02/09/2025.
//

import Tagged

/// Property wrapper that defines a value as a dynamic measure, offering a solution to create
/// `Tagged`-like `Measurement` for dynamic units.
/// - Unit: Type representing the target unit associated to the quantity.
/// - Quantity: Type representing the quantity defined.
/// 
/// Provides conversion for other dynamic units of the same type and `Tagged` base values.
/// 
/// Example:
/// ```swift
/// @Measured(\.length, in: { $0.meters }) var distance = 35 // 35 meters
/// ```
@propertyWrapper
public struct Measured<Unit: Convertible, Quantity> {
    // MARK: Variables
    /// Internal wrapped measurement.
    var measurement: Measurement<Unit, Quantity>
    /// Converter from current unit towards base value.
    var base: @Sendable (Measurement<Unit, Quantity>) -> Tagged<Unit.Base, Quantity>
    /// Converter from base value to a given unit.
    var converter: @Sendable (Tagged<Unit.Base, Quantity>) -> Measurement<Unit, Quantity>
    /// Returns the wrapped measurement in a given unit.
    public var wrappedValue: Quantity {
        get { measurement.value }
        set { measurement.value = newValue }
    }
    // MARK: Initializers
    /// Creates a new `@Measured` instance for a given unit.
    /// - Parameters:
    ///   - value: Quantity in the given unit.
    ///   - base: Converter used to obtain the base value.
    ///   - converter: Converter used to derive quantity from the base value.
    ///
    /// Note: This initializer does not treat `value` as a raw representation, but the actual quantity of the unit
    public init(
        wrappedValue value: Quantity,
        _ base: @escaping @Sendable (Measurement<Unit, Quantity>) -> Tagged<Unit.Base, Quantity>,
        in converter: @escaping @Sendable (Tagged<Unit.Base, Quantity>) -> Measurement<Unit, Quantity>
    ) where Unit: Sendable {
        self.measurement = Measurement(value, converter(.init(value)).unit)
        self.base = base
        self.converter = converter
    }
    // MARK: Methods
    /// Sets the value to be the same as another measurement.
    /// - Parameter newValue: Measurement.
    public mutating func setValue(
        _ newValue: Measurement<Unit, Quantity>
    ) where Unit: Convertible {
        measurement = converter(base(newValue))
    }
    /// Sets the value to be the same as a tagged measure.
    /// - Parameter tagged: Tagged measure.
    public mutating func setValue<T: Domain>(
        _ tagged: Tagged<T, Quantity>
    ) where Unit.Base == T {
        measurement = converter(tagged)
    }
}

// MARK: Self: Equatable
extension Measured: Equatable where Unit: Equatable, Quantity: Equatable {
    // swiftlint:disable:next missing_docs
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.measurement == rhs.measurement
    }
}

// MARK: Self: Measurable
extension Measured: Measurable {
    // swiftlint:disable:next missing_docs
    public var quantity: Quantity { measurement.value }
}

// MARK: Self: Sendable
extension Measured: Sendable where Unit: Sendable, Quantity: Sendable {}
