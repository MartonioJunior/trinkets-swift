//
//  Exponential+Power.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/05/2026.
//

import Notation
import Tagged

// MARK: N == 0
@available(macOS 26.0, *)
public extension Measurement {
    /// Unwraps the measure as a value.
    /// - Returns: Quantity associated with the measure.
    func unwrapValue<T>(_: T.Type = T.self) -> Value where UnitType == Unitless<T> { value }
}

@available(macOS 26.0, *)
public extension Tagged {
    /// Unwraps the measure as a value.
    /// - Returns: Quantity associated with the measure.
    func unwrapValue<T>(_: T.Type = T.self) -> RawValue where Tag == Unitless<T> { rawValue }
}

// MARK: N == 1
@available(macOS 26.0, *)
public extension Measurement {
    /// Unwraps the measure as is.
    /// - Returns: Measurement with the unwrapped unit.
    func unwrapMeasure<T: Measurable>(_: T.Type = T.self) -> Measurement<T, Value> where UnitType == Linear<T> {
        .init(value, unit.base)
    }
}

@available(macOS 26.0, *)
public extension Tagged {
    /// Unwraps the measure as is.
    /// - Returns: Tagged value with the unwrapped unit.
    func unwrapMeasure<T>(_ type: T.Type = T.self) -> Tagged<T, RawValue> where Tag == Linear<T> {
        coerced(to: type)
    }
}

@available(macOS 26.0, *)
public extension Exponential where N == 1 {}

// MARK: N == 2
@available(macOS 26.0, *)
public extension Exponential where N == 2 {
    /// Symbol for a squared unit.
    static var symbol: UnitRepresentation {
        .init(symbol: .Units.squareSymbol, name: SyntaxFunction {
            .Units.squareName(suffix: "\($0)")
        })
    }
    /// Creates a squared unit.
    /// - Parameter unit: Base unit.
    /// - Returns: A new `Exponential` with `N` == 2.
    static func square(_ unit: T) -> Self where T: Measurable {
        .init(unit)
    }
}

@available(macOS 26.0, *)
public extension Measurement where UnitType: Measurable & Equatable, Value: Numeric {
    /// Attempts to multiply two measurements together.
    /// - Parameters:
    ///   - lhs: A measure.
    ///   - rhs: Another measure.
    ///
    /// - Returns: The square measurement with the product of values when the units are the same, `nil` otherwise.
    static func * (lhs: Self, rhs: Self) -> Measurement<Square<UnitType>, Value>? {
        guard lhs.unit == rhs.unit else { return nil }

        return .init(lhs.value * rhs.value, .init(lhs.unit))
    }
}

@available(macOS 26.0, *)
public extension Tagged where Tag: Domain, RawValue: Numeric {
    /// Multiplies the two tagged values together.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    ///
    /// - Returns: A new tagged value with the square tag.
    static func * (lhs: Self, rhs: Self) -> Tagged<Square<Tag>, RawValue> {
        .init(lhs.rawValue * rhs.rawValue)
    }
}

@available(macOS 26.0, *)
public extension Tagged where Tag: StaticUnit, RawValue: Numeric {
    /// Multiplies the two tagged values together.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: Another tagged value.
    ///
    /// - Returns: A new tagged value with the square tag.
    static func * (lhs: Self, rhs: Self) -> Tagged<Square<Tag>, RawValue> {
        .init(lhs.rawValue * rhs.rawValue)
    }
}

// MARK: N == 3
@available(macOS 26.0, *)
public extension Exponential where N == 3 {
    /// Symbol for a cubic unit.
    static var symbol: UnitRepresentation {
        .init(symbol: .Units.cubicSymbol, name: SyntaxFunction {
            .Units.cubicName(suffix: "\($0)")
        })
    }
    /// Creates a cubic unit.
    /// - Parameter unit: Base unit.
    /// - Returns: A new `Exponential` with `N` == 3.
    static func cubic(_ unit: T) -> Self where T: Measurable {
        .init(unit)
    }
}

@available(macOS 26.0, *)
public extension Measurement where UnitType: Measurable & Equatable, Value: Numeric {
    /// Attempts to multiply a squared measure with a measurement.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: A squared measurement.
    ///
    /// - Returns: The square measurement with the product of values when the units are the same, `nil` otherwise.
    static func * (lhs: Self, rhs: Measurement<Square<UnitType>, Value>) -> Measurement<Cubic<UnitType>, Value>? {
        guard lhs.unit == rhs.unit.base else { return nil }

        return .init(lhs.value * rhs.value, .init(lhs.unit))
    }
    /// Attempts to multiply a squared measure with a measurement.
    /// - Parameters:
    ///   - lhs: A squared measurement.
    ///   - rhs: A measurement.
    ///
    /// - Returns: The square measurement with the product of values when the units are the same, `nil` otherwise.
    static func * (lhs: Measurement<Square<UnitType>, Value>, rhs: Self) -> Measurement<Cubic<UnitType>, Value>? {
        guard lhs.unit.base == rhs.unit else { return nil }

        return .init(lhs.value * rhs.value, .init(lhs.unit.base))
    }
}

@available(macOS 26.0, *)
public extension Tagged where Tag: StaticUnit, RawValue: Numeric {
    /// Attempts to multiply a squared tagged value with a tagged value.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: A squared tagged value.
    ///
    /// - Returns: The square tagged value with the product of values.
    static func * (lhs: Self, rhs: Tagged<Square<Tag>, RawValue>) -> Tagged<Cubic<Tag>, RawValue> {
        .init(lhs.rawValue * rhs.rawValue)
    }
    /// Attempts to multiply a squared tagged value with a tagged value.
    /// - Parameters:
    ///   - lhs: A squared tagged value.
    ///   - rhs: A tagged value.
    ///
    /// - Returns: The square tagged value with the product of values.
    static func * (lhs: Tagged<Square<Tag>, RawValue>, rhs: Self) -> Tagged<Cubic<Tag>, RawValue> {
        .init(lhs.rawValue * rhs.rawValue)
    }
}

@available(macOS 26.0, *)
public extension Tagged where Tag: Domain, RawValue: Numeric {
    /// Attempts to multiply a squared tagged value with a tagged value.
    /// - Parameters:
    ///   - lhs: A tagged value.
    ///   - rhs: A squared tagged value.
    ///
    /// - Returns: The square tagged value with the product of values.
    static func * (lhs: Self, rhs: Tagged<Square<Tag>, RawValue>) -> Tagged<Cubic<Tag>, RawValue> {
        .init(lhs.rawValue * rhs.rawValue)
    }
    /// Attempts to multiply a squared tagged value with a tagged value.
    /// - Parameters:
    ///   - lhs: A squared tagged value.
    ///   - rhs: A tagged value.
    ///
    /// - Returns: The square tagged value with the product of values.
    static func * (lhs: Tagged<Square<Tag>, RawValue>, rhs: Self) -> Tagged<Cubic<Tag>, RawValue> {
        .init(lhs.rawValue * rhs.rawValue)
    }
}
