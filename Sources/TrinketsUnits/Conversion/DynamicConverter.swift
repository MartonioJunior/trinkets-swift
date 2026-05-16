//
//  DynamicConverter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/05/2026.
//

/// Converter that defines a transformation between unit instances of the same type.
public typealias DynamicUnitConverter<Unit, Value> = DynamicConverter<Unit, Unit, Value>
/// Converter that defines a transformation from a dynamic unit to a base value (and vice-versa).
/// 
/// Allows the conversion between a static and a dynamic context.
public struct DynamicConverter<Unit, Reference, Value> {
    // MARK: Variables
    var f: (Unit, Value) -> Value
    /// Wraps the converter as a `StaticConverter` instance.
    /// 
    /// Unit is defined as the origin of the transformation.
    var asStaticOrigin: (Unit) -> StaticConverter<Unit, Reference, Value> {
        { unit in .init { f(unit, $0) } }
    }
    /// Wraps the converter as a `StaticConverter` instance.
    /// 
    /// Unit is defined as the target of the transformation.
    var asStaticTarget: (Unit) -> StaticConverter<Reference, Unit, Value> {
        { unit in .init { f(unit, $0) } }
    }
    // MARK: Initializers
    /// Creates a new converter.
    /// - Parameter f: Transformation function.
    public init(_ f: @escaping (Unit, Value) -> Value) {
        self.f = f
    }
}

// MARK: DotSyntax
public extension DynamicConverter {
    /// Creates a dynamic converter from a static one.
    /// - Parameter selector: Function that select which converter to use for a given dynamic unit.
    /// - Returns: A new dynamic converter.
    static func from(_ selector: @escaping (Unit) -> StaticConverter<Unit, Reference, Value>) -> Self {
        .init { selector($0).f($1) }
    }
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
        _ base: StaticConverter<Reference, Reference.Base, Value>,
        _ converter: DynamicConverter<Unit, Reference.Base, Value>
    ) -> Self where Reference: StaticUnit {
        .init { converter.f($0, base.f($1)) }
    }
    /// Creates a converter from a dynamic unit to a static one.
    /// - Parameters:
    ///   - base: Converter to base value.
    ///   - converter: Converter from base value to desired static unit.
    ///
    /// - Returns: A new dynamic converter.
    static func toStatic(
        _ base: DynamicConverter<Unit, Reference.Base, Value>,
        _ converter: StaticConverter<Reference.Base, Reference, Value>
    ) -> Self where Reference: StaticUnit {
        .init { converter.f(base.f($0, $1)) }
    }
}
