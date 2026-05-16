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
public struct PrefixedUnit<Prefix: UnitPrefix, Unit> {
    /// Unit used as the base.
    var unit: Unit
    // MARK: Initializers
    /// Creates a new dynamic prefixed unit instance.
    /// - Parameters:
    ///   - unit: Base unit.
    ///
    public init(_: Prefix.Type = Prefix.self, _ unit: Unit) where Unit: Measurable {
        self.unit = unit
    }
    /// Creates a new dynamic prefixed unit instance.
    /// - Parameters:
    ///   - unit: Base unit.
    ///
    public init(_: Tagged<Prefix.Base, Prefix.Type>, _ unit: Unit) where Unit: Measurable {
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

// MARK: Self: Measurable
extension PrefixedUnit: Measurable where Unit: Measurable {}

// MARK: Self: StaticUnit
extension PrefixedUnit: StaticUnit where Unit: StaticUnit {}

// MARK: Measurement (EX)
public extension Measurement where Value: Numeric & ExpressibleByFloatLiteral, Value.FloatLiteralType == Double {
    /// Obtains the base value for a measurement with a prefixed unit.
    /// - Parameter converter: Converter from the wrapped unit to the base value. 
    /// - Returns: A new tagged base value.
    func baseValue<Prefix: UnitPrefix, T: Convertible>(
        _ converter: DynamicConverter<T, T.Base, Value>
    ) -> Tagged<T.Base, Value> where UnitType == PrefixedUnit<Prefix, T> {
        unwrapPrefix().baseValue(converter)
    }
    /// Removes the prefix from the unit.
    /// - Returns: A new measurement in the non-prefixed unit.
    func unwrapPrefix<
        Prefix: UnitPrefix,
        Unit: Measurable
    >() -> Measurement<Unit, Value> where UnitType == PrefixedUnit<Prefix, Unit> {
        .init(value * Value(floatLiteral: Prefix.multiplier), unit.unit)
    }
}

public extension Measurement where UnitType: Measurable,
Value: FloatingPoint & ExpressibleByFloatLiteral, Value.FloatLiteralType == Double {
    /// Attaches a prefix to a unit
    /// - Returns: A new measurement under the prefixed unit.
    func setPrefix<Prefix: UnitPrefix>(
        _: Tagged<Prefix.Base, Prefix.Type>
    ) -> Measurement<PrefixedUnit<Prefix, UnitType>, Value> {
        .init(value / Value(floatLiteral: Prefix.multiplier), PrefixedUnit(Prefix.self, unit))
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where RawValue: Numeric & ExpressibleByFloatLiteral, RawValue.FloatLiteralType == Double {
    /// Obtains the base value for a tagged value with a prefixed unit.
    /// - Parameter converter: Converter from the wrapped unit to the base value. 
    /// - Returns: A new tagged base value.
    func baseValue<Prefix: UnitPrefix, Unit: StaticUnit>(
        _ converter: StaticConverter<Unit, Unit.Base, RawValue>
    ) -> Tagged<Unit.Base, RawValue> where Tag == PrefixedUnit<Prefix, Unit> {
        unwrapPrefix().baseValue(converter)
    }
    /// Removes the prefix from the unit.
    /// - Returns: A new tagged value in the non-prefixed unit.
    func unwrapPrefix<
        Prefix: UnitPrefix,
        Unit: StaticUnit
    >() -> Tagged<Unit, RawValue> where Tag == PrefixedUnit<Prefix, Unit> {
        .init(rawValue * RawValue(floatLiteral: Prefix.multiplier))
    }
}

public extension Tagged where Tag: StaticUnit,
RawValue: FloatingPoint & ExpressibleByFloatLiteral, RawValue.FloatLiteralType == Double {
    /// Attaches a prefix to a unit
    /// - Returns: A new tagged value under the prefixed unit.
    func setPrefix<Prefix: UnitPrefix>(
        _: Tagged<Prefix.Base, Prefix.Type>
    ) -> Tagged<PrefixedUnit<Prefix, Tag>, RawValue> {
        .init(rawValue / RawValue(floatLiteral: Prefix.multiplier))
    }
}

// TODO: Add methods for direct conversion from one prefix to another.
public extension Tagged where RawValue: FloatingPoint & ExpressibleByFloatLiteral, RawValue.FloatLiteralType == Double {
    /// Converts base value to a prefixed unit.
    /// - Parameters:
    ///   - prefix: Prefix used.
    ///   - converter: Converter from base value to non-prefixed unit.
    ///
    /// - Returns: A new tagged value under the prefixed unit.
    func converted<Prefix: UnitPrefix, T: StaticUnit>(
        to prefix: Tagged<Prefix.Base, Prefix.Type>,
        _ converter: StaticConverter<Tag, T, RawValue>
    ) -> Tagged<PrefixedUnit<Prefix, T>, RawValue> {
        converted(to: converter).setPrefix(prefix)
    }
    /// Converts base value to a prefixed unit.
    /// - Parameters:
    ///   - prefix: Prefix used.
    ///   - converter: Converter from base value to non-prefixed unit.
    ///
    /// - Returns: A new measurement under the prefixed unit.
    func converted<Prefix: UnitPrefix, T: Convertible>(
        to prefix: Tagged<Prefix.Base, Prefix.Type>,
        _ unit: T,
        converter: DynamicConverter<T, Tag, RawValue>
    ) -> Measurement<PrefixedUnit<Prefix, T>, RawValue> where Tag == T.Base {
        converted(to: unit, converter).setPrefix(prefix)
    }
}
