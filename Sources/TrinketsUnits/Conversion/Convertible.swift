//
//  Convertible.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/09/2025.
//

import Tagged

/// Unit or quantifiable aspect that can be converted to a base.
/// 
/// Works as a marker protocol to allow conversion between different units that share the same base.
public protocol Convertible: Measurable {
    /// Type representing the base of conversion.
    associatedtype Base = Self
}

// MARK: Measurement (EX)
public extension Measurement where UnitType: Convertible {
    /// Base value of this measure.
    /// - Parameter converter: Converter used to obtain the base value.
    /// - Returns: A tagged value that represents the base value.
    func baseValue(_ converter: DynamicConverter<UnitType, UnitType.Base, Value>) -> Tagged<UnitType.Base, Value> {
        .init(converter.f(unit, value))
    }
    /// Converts the measure to another unit.
    /// - Parameters:
    ///   - newUnit: Target unit.
    ///   - base: Converter from current unit to base value.
    ///   - converter: Converter from base value to target unit.
    ///
    /// - Returns: A new `Measurement` in the new unit.
    func converted<T: Convertible>(
        to newUnit: T,
        _ base: DynamicConverter<UnitType, UnitType.Base, Value>,
        _ converter: DynamicConverter<T, T.Base, Value>
    ) -> Measurement<T, Value> where UnitType.Base == T.Base {
        baseValue(base).converted(to: newUnit, converter)
    }
    /// Converts value to a static unit.
    /// - Parameter converter: Converter to the static unit.
    /// - Returns: A tagged value.
    func converted<T: StaticUnit>(
        _ converter: DynamicConverter<UnitType, T, Value>
    ) -> Tagged<T, Value> {
        .init(converter.f(unit, value))
    }
}

// MARK: Tagged (EX)
public extension Tagged where Tag: StaticUnit {
    /// Base value of this measure.
    /// - Parameter converter: Converter used to obtain the base value.
    /// - Returns: A tagged value that represents the base value.
    func baseValue(
        _ converter: StaticConverter<Tag, Tag.Base, RawValue>
    ) -> Tagged<Tag.Base, RawValue> {
        .init(converter.f(rawValue))
    }
    /// Converts the tagged value to another static unit.
    /// - Parameters:
    ///   - base: Converter from current unit to base value.
    ///   - converter: Converter from base value to target unit.
    ///
    /// - Returns: A new tagged value in the new unit.
    func converted<T: StaticUnit>(
        _ base: StaticConverter<Tag, Tag.Base, RawValue>,
        _ converter: StaticConverter<T.Base, T, RawValue>
    ) -> Tagged<T, RawValue> where Tag.Base == T.Base {
        baseValue(base).converted(to: converter)
    }
}

public extension Tagged {
    /// Converts the tagged value to another static unit.
    /// - Parameter converter: Converter to static unit.
    /// - Returns: A new tagged value in the new unit.
    func converted<T: StaticUnit>(
        to converter: StaticConverter<Tag, T, RawValue>
    ) -> Tagged<T, RawValue> {
        .init(converter.f(rawValue))
    }
    /// Converts value to a dynamic unit.
    /// - Parameters:
    ///   - newUnit: Target unit.
    ///   - converter: Converter to the dynamic unit.
    /// - Returns: A measurement in the new unit.
    func converted<T: Convertible>(
        to newUnit: T,
        _ converter: DynamicConverter<T, Tag, RawValue>
    ) -> Measurement<T, RawValue> where Tag == T.Base {
        .init(converter.f(newUnit, rawValue), newUnit)
    }
}
