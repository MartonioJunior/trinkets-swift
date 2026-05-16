//
//  AnyUnit.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/04/2026.
//

import Tagged

/// Data structure that stores a type-erased unit.
public struct AnyUnit {
    // MARK: Variables
    /// Stored unit.
    var unit: Any
    // MARK: Initializers
    /// Erases a dynamic unit.
    /// - Parameter unit: Dynamic unit.
    public init<M: Measurable>(_ unit: M) {
        self.unit = unit
    }
    /// Erases a static unit.
    /// - Parameter unitType: Static unit.
    public init<S: StaticUnit>(_ unitType: S.Type) {
        self.unit = unitType
    }
    // MARK: Methods
    /// Unwraps the stored value as a dynamic unit.
    /// - Returns: Dynamic unit, `nil` otherwise.
    public func asDynamic<M: Measurable>(_: M.Type) -> M? {
        unit as? M
    }
    /// Unwraps the stored value as a static unit.
    /// - Returns: Static unit, `nil` otherwise.
    public func asStatic<S: StaticUnit>(_: S.Type) -> S.Type? {
        unit as? S.Type
    }
}

// MARK: Self: CustomStringConvertible
extension AnyUnit: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { String(describing: unit) }
}

// MARK: Self: Measurable
extension AnyUnit: Measurable {}

// MARK: Measurement (EX)
public extension Measurement where UnitType == AnyUnit {
    /// Unwraps the dynamic unit.
    /// - Parameter type: Target type.
    /// - Returns: A measurement with the unwrapped dynamic unit, `nil` otherwise.
    func asDynamic<M: Measurable>(_ type: M.Type) -> Measurement<M, Value>? {
        guard let dynamicUnit = unit.asDynamic(type) else { return nil }

        return .init(value, dynamicUnit)
    }
    /// Unwraps the static unit.
    /// - Parameter type: Target type.
    /// - Returns: A tagged value with the unwrapped static unit, `nil` otherwise.
    func asStatic<S: StaticUnit>(_ type: S.Type) -> Tagged<S, Value>? {
        guard unit.asStatic(type) != nil else { return nil }

        return .init(value)
    }
}
