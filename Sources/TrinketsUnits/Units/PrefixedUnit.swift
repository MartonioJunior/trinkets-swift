//
//  PrefixedUnit.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/04/2026.
//

/// Unit composed of a prefix that multiplies the quantity of a base unit.
/// 
/// This allows for better value precision to a given context when compared to using an unit as is,
/// except in cases where the quantity is already close to the base.
public struct PrefixedUnit<Prefix: UnitPrefix, Unit: Quantifiable> {
    /// Unit used as the base.
    var unit: Unit
    // MARK: Initializers
    /// Creates a new dynamic prefixed unit instance.
    /// - Parameters:
    ///   - unit: Base unit.
    ///
    public init(_: Prefix.Type = Prefix.self, _ unit: Unit) {
        self.unit = unit
    }
    /// Creates a new dynamic prefixed unit instance.
    /// - Parameters:
    ///   - unit: Base unit.
    ///
    public init(_: Tagged<Prefix.Base, Prefix.Type>, _ unit: Unit) {
        self.unit = unit
    }
}

// MARK: Self: Convertible
extension PrefixedUnit: Convertible where Unit: Convertible {
    // swiftlint:disable:next missing_docs
    public typealias Base = Unit.Base
}

// MARK: Self: CustomStringConvertible
extension PrefixedUnit: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { "\(Prefix.self)\(unit)" }
}

// MARK: Self: Equatable
extension PrefixedUnit: Equatable where Unit: Equatable {}

// MARK: Self: Quantifiable
extension PrefixedUnit: Quantifiable where Unit: Quantifiable {}

// MARK: Self: StaticQuantifiable
extension PrefixedUnit: StaticQuantifiable where Unit: StaticQuantifiable {}

// MARK: Self: StaticUnit
extension PrefixedUnit: StaticUnit where Unit: StaticUnit {}

// MARK: Measurement (EX)
public extension Measurement where Value: Numeric & ExpressibleByFloatLiteral, Value.FloatLiteralType == Double {
    /// Removes the prefix from the unit.
    /// - Returns: A new measurement in the non-prefixed unit.
    func unprefixed<
        Prefix: UnitPrefix,
        Unit: Quantifiable
    >() -> Measurement<Unit, Value> where UnitType == PrefixedUnit<Prefix, Unit> {
        .init(value * Value(floatLiteral: Prefix.multiplier), unit.unit)
    }
}

public extension Measurement where UnitType: Quantifiable,
Value: FloatingPoint & ExpressibleByFloatLiteral, Value.FloatLiteralType == Double {
    /// Attaches a prefix to a unit
    /// - Returns: A new measurement under the prefixed unit.
    func prefixed<Prefix: UnitPrefix>(
        with _: Tagged<Prefix.Base, Prefix.Type>
    ) -> Measurement<PrefixedUnit<Prefix, UnitType>, Value> {
        .init(value / Value(floatLiteral: Prefix.multiplier), PrefixedUnit(Prefix.self, unit))
    }
    /// Changes the prefix used in the measurement.
    /// - Parameter newPrefix: New prefix for the measurement
    /// - Returns: A new tagged value in the non-prefixed unit.
    func reprefixed<
        A: UnitPrefix,
        B: UnitPrefix,
        Unit: Quantifiable
    >(
        to newPrefix: Tagged<B.Base, B.Type>
    ) -> Measurement<PrefixedUnit<B, Unit>, Value> where UnitType == PrefixedUnit<A, Unit> {
        unprefixed().prefixed(with: newPrefix)
        // .init(rawValue * RawValue(floatLiteral: A.multiplier))
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where RawValue: Numeric & ExpressibleByFloatLiteral, RawValue.FloatLiteralType == Double {
    /// Removes the prefix from the unit.
    /// - Returns: A new tagged value in the non-prefixed unit.
    func unprefixed<
        Prefix: UnitPrefix,
        Unit: StaticQuantifiable
    >() -> Tagged<Unit, RawValue> where Tag == PrefixedUnit<Prefix, Unit> {
        .init(rawValue * RawValue(floatLiteral: Prefix.multiplier))
    }
}

public extension Tagged where Tag: Domain, RawValue: FloatingPoint & ExpressibleByFloatLiteral,
RawValue.FloatLiteralType == Double {
    /// Converts base value to a prefixed unit.
    /// - Parameters:
    ///   - prefix: Prefix used.
    ///   - converter: Converter from base value to non-prefixed unit.
    ///
    /// - Returns: A new tagged value under the prefixed unit.
    /// 
    /// Example:
    /// ```swift
    /// let barometricValue = pressure.converted(to: .milli, \.bars)
    /// ```
    func converted<Prefix: UnitPrefix, T: StaticQuantifiable>(
        to prefix: Tagged<Prefix.Base, Prefix.Type>,
        _ converter: (Tagged<Tag, RawValue>) -> Tagged<T, RawValue>
    ) -> Tagged<PrefixedUnit<Prefix, T>, RawValue> {
        converter(self).prefixed(with: prefix)
    }
}

public extension Tagged where Tag: StaticQuantifiable, RawValue: FloatingPoint & ExpressibleByFloatLiteral, RawValue.FloatLiteralType == Double {
    /// Attaches a prefix to a unit
    /// - Returns: A new tagged value under the prefixed unit.
    func prefixed<Prefix: UnitPrefix>(
        with _: Tagged<Prefix.Base, Prefix.Type>
    ) -> Tagged<PrefixedUnit<Prefix, Tag>, RawValue> {
        .init(rawValue / RawValue(floatLiteral: Prefix.multiplier))
    }
    /// Changes the prefix used in the measurement.
    /// - Parameter newPrefix: New prefix for the measurement
    /// - Returns: A new tagged value in the non-prefixed unit.
    func reprefixed<
        A: UnitPrefix,
        B: UnitPrefix,
        Unit: StaticQuantifiable
    >(
        to newPrefix: Tagged<B.Base, B.Type>
    ) -> Tagged<PrefixedUnit<B, Unit>, RawValue> where Tag == PrefixedUnit<A, Unit> {
        unprefixed().prefixed(with: newPrefix)
    }
}
