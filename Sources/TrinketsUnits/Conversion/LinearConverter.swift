//
//  LinearConverter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/06/2025.
//

import Foundation

@available(macOS, introduced: 13, deprecated: 26.0, message: "Use PolynomialFunction<1, Double> instead.")
public struct LinearConverter {
    // MARK: Variables
    public var constant: Double
    public var coefficient: Double

    // MARK: Initializers
    public init(_ a: Double, k: Double = 0) {
        self.coefficient = a
        self.constant = k
    }

    // MARK: Operators
    static func * (lhs: Self, rhs: Double) -> Self {
        .init(lhs.coefficient * rhs, k: lhs.constant * rhs)
    }

    static func / (lhs: Self, rhs: Double) -> Self? {
        guard rhs != 0 else { return nil }

        return .init(lhs.coefficient / rhs, k: lhs.constant / rhs)
    }
}

// MARK: DotSyntax
public extension LinearConverter {
    static var base: Self { .init(1) }

    static func linear(_ a: Double, k: Double = 0) -> Self { .init(a, k: k) }
}

// MARK: Self: Comparable
extension LinearConverter: Comparable {
    public static func < (lhs: LinearConverter, rhs: LinearConverter) -> Bool {
        if lhs.coefficient < rhs.coefficient {
            lhs.constant <= rhs.constant
        } else if lhs.coefficient == rhs.coefficient {
            lhs.constant < rhs.constant
        } else {
            false
        }
    }

    public static func <= (lhs: LinearConverter, rhs: LinearConverter) -> Bool {
        lhs.coefficient <= rhs.coefficient && lhs.constant <= rhs.constant
    }

    public static func >= (lhs: LinearConverter, rhs: LinearConverter) -> Bool {
        lhs.coefficient >= rhs.coefficient && lhs.constant >= rhs.constant
    }

    public static func > (lhs: LinearConverter, rhs: LinearConverter) -> Bool {
        if lhs.coefficient > rhs.coefficient {
            lhs.constant >= rhs.constant
        } else if lhs.coefficient == rhs.coefficient {
            lhs.constant > rhs.constant
        } else {
            false
        }
    }
}

// MARK: Self: Converter
extension LinearConverter: Converter {
    public typealias Value = Double

    public func baseValue(of value: Value) -> Value {
        coefficient * value + constant
    }

    public func convert(_ baseValue: Double) -> Double? {
        (baseValue - constant) / coefficient
    }
}

// MARK: Self: Equatable
extension LinearConverter: Equatable {}

// MARK: Self: Sendable
extension LinearConverter: Sendable {}
