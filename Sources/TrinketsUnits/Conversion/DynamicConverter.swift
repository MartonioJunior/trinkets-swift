//
//  DynamicConverter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/05/2026.
//

import Tagged

/// Converter that defines a transformation between unit instances of the same type.
public typealias DynamicUnitConverter<Unit, Value> = DynamicConverter<Unit, Unit, Value>
/// Converter that defines a transformation from a dynamic unit to a base value (and vice-versa).
/// 
/// Allows the conversion between a static and a dynamic context.
public struct DynamicConverter<Unit, Reference, Value> {
    // MARK: Variables
    var f: (Unit, Value) -> Value
    // MARK: Initializers
    /// Creates a new converter.
    /// - Parameter f: Transformation function.
    public init(_ f: @escaping (Unit, Value) -> Value) {
        self.f = f
    }
}

// MARK: DotSyntax
public extension DynamicConverter {
    /// Converts a value from a measurement to a reference value.
    /// - Parameter f: Transformation function.
    /// - Returns: A new dynamic converter.
    static func toBase(
        _ f: @escaping (Measurement<Unit, Value>) -> Value
    ) -> Self where Unit: Measurable {
        .init { f(.init($1, $0)) }
    }
    /// Converts a value from the reference to a given unit
    /// - Parameter f: Transformation function.
    /// - Returns: A new dynamic converter.
    static func baseToUnit(
        _ f: @escaping (Value, Unit) -> Value
    ) -> Self where Unit: Measurable {
        .init { f($1, $0) }
    }
}

// MARK: Self: Sendable
extension DynamicConverter: @unchecked Sendable {}

// MARK: Self.Reference: StaticUnit
public extension DynamicConverter {
    /// Creates a converter from a static unit to a dynamic one.
    /// - Parameters:
    ///   - base: Converter to base value.
    ///   - converter: Converter from base value to desired unit.
    ///
    /// - Returns: A new dynamic converter.
    static func fromStatic(
        _ base: @escaping (Tagged<Reference, Value>) -> Tagged<Reference.Base, Value>,
        _ converter: DynamicConverter<Unit, Reference.Base, Value>
    ) -> Self where Reference: StaticUnit {
        .init { converter.f($0, base(.init($1)).rawValue) }
    }
    /// Creates a converter from a dynamic unit to a static one.
    /// - Parameters:
    ///   - base: Converter to base value.
    ///   - converter: Converter from base value to desired static unit.
    ///
    /// - Returns: A new dynamic converter.
    static func toStatic(
        _ base: DynamicConverter<Unit, Reference.Base, Value>,
        _ converter: @escaping (Tagged<Reference.Base, Value>) -> Tagged<Reference, Value>
    ) -> Self where Reference: StaticUnit {
        .init { converter(.init(base.f($0, $1))).rawValue }
    }
}
