//
//  Tally.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2025.
//

/// Quantity of a stock in inventory.
public enum Tally {
    /// Primitive representing the tally's quantity.
    public typealias Value = UInt
    // MARK: Cases
    /// Fixed quantity supplied.
    case fixed(Value)
    /// Infinite supply.
    case infinite
    /// No supply available.
    case nullify
    // MARK: Properties
    /// Amount of stock, as represented by the primitive type.
    /// 
    /// Using this directly in an arithmetic operation may require handling any overflow that may happen as a result of the infinite supply.
    public var amount: Value {
        switch self {
            case .fixed(let amount): amount
            case .infinite: .max
            case .nullify: .zero
        }
    }
    /// Is there stock available?
    public var inStock: Bool {
        switch self {
            case .fixed(let amount): amount != 0
            case .infinite: true
            case .nullify: false
        }
    }
    // MARK: Methods
    /// Handles an overflow structure with a fallback value.
    /// - Parameters:
    ///   - result: Result of the operation that can overflow.
    ///   - fallback: Value to use if the value has overflowed.
    ///
    /// - Returns: Selected value.
    private static func manage(_ result: (partialValue: Value, overflow: Bool), fallback: Value) -> Value {
        result.overflow ? fallback : result.partialValue
    }
}

// MARK: Operators
public extension Tally {
    /// Adds a value to a tally.
    /// - Parameters:
    ///   - lhs: Tally.
    ///   - rhs: Value to be added.
    ///
    /// - Returns: Tally with the value added. If the stock is not a fixed value, returns the left-hand side unchanged.
    static func + (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .fixed(let a): .fixed(manage(a.addingReportingOverflow(rhs), fallback: .max))
            default: lhs
        }
    }
    /// Adds a value to a tally.
    /// - Parameters:
    ///   - lhs: Tally to be mutated.
    ///   - rhs: Value to be added to the tally.
    ///
    static func += (lhs: inout Self, rhs: Value) {
        lhs = lhs + rhs
    }
    /// Subtracts a value from the tally.
    /// - Parameters:
    ///   - lhs: Tally.
    ///   - rhs: Value to be subtracted.
    ///
    /// - Returns: Tally with the value subtracted. If the stock is not a fixed value, returns the left-hand side unchanged.
    static func - (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .fixed(let a): .fixed(manage(a.subtractingReportingOverflow(rhs), fallback: .zero))
            default: lhs
        }
    }
    /// Subtracts a value from the tally.
    /// - Parameters:
    ///   - lhs: Tally to be mutated.
    ///   - rhs: Value to be subtracted.
    ///
    static func -= (lhs: inout Self, rhs: Value) {
        lhs = lhs - rhs
    }
    /// Multiplies a value.
    /// - Parameters:
    ///   - lhs: Tally.
    ///   - rhs: Value to multiply.
    ///
    /// - Returns: Tally multiplied by the value. If the stock is not a fixed value, returns the left-hand side unchanged.
    static func * (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .fixed(let a): .fixed(manage(a.multipliedReportingOverflow(by: rhs), fallback: .max))
            default: lhs
        }
    }
    /// Attempts to multiply two tallies together.
    /// - Parameters:
    ///   - lhs: Tally.
    ///   - rhs: Another tally.
    ///
    /// - Returns: Resulting tally, which can change based on the following rules:
    ///   - Fixed tallies can be multiplied by itself.
    ///   - Infinite multiplied by nullify is `nil`.
    ///   - Infinite and nullify multiplied by anything else is themselves.
    static func * (lhs: Self, rhs: Self) -> Self? {
        switch (lhs, rhs) {
            case let (.fixed(a), .fixed(b)):
                .fixed(manage(a.multipliedReportingOverflow(by: b), fallback: .max))
            case (.infinite, .nullify), (.nullify, .infinite):
                nil
            case (.infinite, _), (_, .infinite):
                .infinite
            case (.nullify, _), (_, .nullify):
                .nullify
        }
    }
    /// Multiplies a tally to a value.
    /// - Parameters:
    ///   - lhs: Tally to be mutated.
    ///   - rhs: Value to multiply.
    ///
    static func *= (lhs: inout Self, rhs: Value) {
        lhs = lhs * rhs
    }
    /// Divides a tally by a value.
    /// - Parameters:
    ///   - lhs: Tally.
    ///   - rhs: Divisor value.
    ///
    /// - Returns: Tally divided by the value. If the stock is not a fixed value, returns the left-hand side unchanged.
    static func / (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .fixed(let a): .fixed(manage(a.dividedReportingOverflow(by: rhs), fallback: .zero))
            default: lhs
        }
    }
    /// Attempts to divide a tally by another.
    /// - Parameters:
    ///   - lhs: Tally.
    ///   - rhs: Another tally.
    ///
    /// - Returns: Resulting tally, which can changed based on the following rules:
    ///   - Dividing a tally by itself returns one.
    ///   - Fixed tallies return the division while reporting underflow (fallback is zero).
    ///   - Dividing nullify or infinite by anything else returns the left-hand side.
    ///   - Dividing anything by infinite returns zero.
    static func / (lhs: Self, rhs: Self) -> Self? {
        switch (lhs, rhs) {
            case let (.fixed(a), .fixed(b)): .fixed(manage(a.dividedReportingOverflow(by: b), fallback: .zero))
            case (.infinite, .infinite), (.nullify, .nullify): .one
            case (_, .nullify): nil
            case (.nullify, _): .nullify
            case (.infinite, _): .infinite
            case (_, .infinite): .zero
        }
    }
    /// Divides a tally by a given value
    /// - Parameters:
    ///   - lhs: Tally to be mutated.
    ///   - rhs: Value to be divided.
    ///
    static func /= (lhs: inout Self, rhs: Value) {
        lhs = lhs / rhs
    }
}

// MARK: DotSyntax
public extension Tally {
    /// Alias for a fixed supply of 1.
    static var one: Self { fixed(1) }
}

// MARK: Self: AdditiveArithmetic
extension Tally: AdditiveArithmetic {
    // swiftlint:disable:next missing_docs
    public static var zero: Self { .fixed(0) }
    // swiftlint:disable:next missing_docs
    public static func + (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case let (.fixed(a), .fixed(b)): .fixed(manage(a.addingReportingOverflow(b), fallback: .max))
            case (.infinite, _), (_, .infinite): .infinite
            case (.nullify, _), (_, .nullify): .nullify
        }
    }
    // swiftlint:disable:next missing_docs
    public static func - (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, .infinite): .zero
            case let (.fixed(a), .fixed(b)): .fixed(manage(a.subtractingReportingOverflow(b), fallback: .zero))
            case (_, .nullify): lhs
            case (.infinite, _): .infinite
            default: .nullify
        }
    }
}

// MARK: Self: Comparable
extension Tally: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.fixed(a), .fixed(b)): a < b
            case (.infinite, _), (_, .nullify): false
            default: true
        }
    }
}

// MARK: Self: Equatable
extension Tally: Equatable {}

// MARK: Self: ExpressibleByIntegerLiteral
extension Tally: ExpressibleByIntegerLiteral {
    // swiftlint:disable:next missing_docs
    public init(integerLiteral value: Value) {
        self = .fixed(value)
    }
}

// MARK: Self: ExpressibleByNilLiteral
extension Tally: ExpressibleByNilLiteral {
    // swiftlint:disable:next missing_docs
    public init(nilLiteral _: ()) {
        self = .nullify
    }
}

// MARK: Self: Sendable
extension Tally: Sendable {}
