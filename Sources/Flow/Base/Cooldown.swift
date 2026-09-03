//
//  Cooldown.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

/// Interval until attaining recovery from a state.
/// 
/// Can be used to define temporary effects of any kind:
/// - Positive Effects (e.g. temporary power-up).
/// - Negative Effects (e.g. vulnerability after an attack).
public struct Cooldown<Interval: AdditiveArithmetic> {
    /// Interval until recovery.
    public var value: Interval
    // MARK: Initializers
    /// Creates a new cooldown.
    /// - Parameter value: Interval until recovery.
    public init(_ value: Interval) {
        self.value = value
    }
}

// MARK: Operators
public extension Cooldown {
    /// Appends a cooldown to a given interval value.
    /// - Parameters:
    ///   - lhs: An interval.
    ///   - rhs: Cooldown to be applied.
    /// - Returns: Appended interval value.
    /// 
    /// When used on an instant, the result is the next recovery point.
    static func + (lhs: Interval, rhs: Self) -> Interval {
        lhs + rhs.value
    }
}

// MARK: Self: AdditiveArithmetic
extension Cooldown: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public static var zero: Self { .init(.zero) }
    // swiftlint:disable:next missing_docs
    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(lhs.value + rhs.value)
    }
    // swiftlint:disable:next missing_docs
    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(lhs.value - rhs.value)
    }
}

// MARK: Self: Comparable
extension Cooldown: Comparable where Interval: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: Self: Equatable
extension Cooldown: Equatable where Interval: Equatable {}

// MARK: Self: ExpressibleByFloatLiteral
extension Cooldown: ExpressibleByFloatLiteral where Interval: ExpressibleByFloatLiteral {
    // swiftlint:disable:next missing_docs
    public init(floatLiteral value: Interval.FloatLiteralType) {
        self.init(.init(floatLiteral: value))
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Cooldown: ExpressibleByIntegerLiteral where Interval: ExpressibleByIntegerLiteral {
    // swiftlint:disable:next missing_docs
    public init(integerLiteral value: Interval.IntegerLiteralType) {
        self.init(.init(integerLiteral: value))
    }
}

// MARK: Self: Sendable
extension Cooldown: Sendable where Interval: Sendable {}

// MARK: Self.Interval: Numeric
public extension Cooldown where Interval: Numeric & Comparable {
    /// Multiplies a value for a given tempo.
    /// - Parameters:
    ///   - lhs: Self to be multiplied.
    ///   - rhs: Tempo multiplier.
    ///
    /// - Returns: Multiplied value.
    static func * (lhs: Self, rhs: Tempo<Interval>) -> Self {
        .init(lhs.value * rhs)
    }
}

// MARK: Strideable (EX)
public extension Strideable {
    /// Indicates the next point of recovery after applying a given cooldown.
    /// - Parameter cooldown: Cooldown to be applied.
    /// - Returns: Instant of the recovery.
    func recovery(after cooldown: Cooldown<Stride>) -> Self {
        advanced(by: cooldown.value)
    }
}
