//
//  Tally.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2025.
//

public enum Tally {
    public typealias Value = UInt

    // MARK: Cases
    case value(Value)
    case infinite
    case nullify

    // MARK: Properties
    public var amount: Value {
        switch self {
            case .value(let amount): amount
            case .infinite: .max
            case .nullify: .zero
        }
    }

    public var inStock: Bool {
        switch self {
            case .value(let amount): amount != 0
            case .infinite: true
            case .nullify: false
        }
    }

    // MARK: Methods
    private static func manage(_ result: (partialValue: Value, overflow: Bool), fallback: Value) -> Value {
        result.overflow ? fallback : result.partialValue
    }
}

// MARK: Operators
public extension Tally {
    static func + (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .value(let a): .value(manage(a.addingReportingOverflow(rhs), fallback: .max))
            default: lhs
        }
    }

    static func += (lhs: inout Self, rhs: Value) {
        lhs = lhs + rhs
    }

    static func - (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .value(let a): .value(manage(a.subtractingReportingOverflow(rhs), fallback: .zero))
            default: lhs
        }
    }

    static func -= (lhs: inout Self, rhs: Value) {
        lhs = lhs - rhs
    }

    static func * (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .value(let a): .value(manage(a.multipliedReportingOverflow(by: rhs), fallback: .max))
            default: lhs
        }
    }

    static func * (lhs: Self, rhs: Self) -> Self? {
        switch (lhs, rhs) {
            case let (.value(a), .value(b)):
                .value(manage(a.multipliedReportingOverflow(by: b), fallback: .max))
            case (.infinite, .nullify), (.nullify, .infinite):
                nil
            case (.infinite, _), (_, .infinite):
                .infinite
            case (.nullify, _), (_, .nullify):
                .nullify
        }
    }

    static func *= (lhs: inout Self, rhs: Value) {
        lhs = lhs * rhs
    }

    static func / (lhs: Self, rhs: Value) -> Self {
        switch lhs {
            case .value(let a): .value(manage(a.dividedReportingOverflow(by: rhs), fallback: .zero))
            default: lhs
        }
    }

    static func / (lhs: Self, rhs: Self) -> Self? {
        switch (lhs, rhs) {
            case let (.value(a), .value(b)): .value(manage(a.dividedReportingOverflow(by: b), fallback: .zero))
            case (.infinite, .infinite), (.nullify, .nullify): .one
            case (_, .nullify): nil
            case (.nullify, _): .nullify
            case (.infinite, _): .infinite
            case (_, .infinite): .zero
        }
    }

    static func /= (lhs: inout Self, rhs: Value) {
        lhs = lhs / rhs
    }
}

// MARK: DotSyntax
public extension Tally {
    static var one: Self { value(1) }
}

// MARK: Self: AdditiveArithmetic
extension Tally: AdditiveArithmetic {
    public static var zero: Self { .value(0) }

    public static func + (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case let (.value(a), .value(b)): .value(manage(a.addingReportingOverflow(b), fallback: .max))
            case (.infinite, _), (_, .infinite): .infinite
            case (.nullify, _), (_, .nullify): .nullify
        }
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        switch (lhs, rhs) {
            case (.infinite, .infinite): .zero
            case let (.value(a), .value(b)): .value(manage(a.subtractingReportingOverflow(b), fallback: .zero))
            case (_, .nullify): lhs
            case (.infinite, _): .infinite
            default: .nullify
        }
    }
}

// MARK: Self: Comparable
extension Tally: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case let (.value(a), .value(b)): a < b
            case (.infinite, _), (_, .nullify): false
            default: true
        }
    }
}

// MARK: Self: Equatable
extension Tally: Equatable {}

// MARK: Self: ExpressibleByIntegerLiteral
extension Tally: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value) {
        self = .value(value)
    }
}

// MARK: Self: ExpressibleByNilLiteral
extension Tally: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .nullify
    }
}

// MARK: Self: Sendable
extension Tally: Sendable {}
