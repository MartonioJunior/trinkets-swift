//
//  PolynomialConverter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

import Foundation
import RealModule

@available(macOS 26.0, *)
public typealias PolynomialConverter<let N: Int, T: Numeric> = PolynomialFunction<N, T>

@available(macOS 26.0, *)
public struct PolynomialFunction<let N: Int, T: Numeric> {
    // MARK: Variables
    var coefficients: InlineArray<N, T>

    public var constant: T { coefficients[N - 1] }

    // MARK: Subscripts
    public subscript(e power: Int) -> T {
        guard 0..<N ~= power else { return .zero }

        return coefficients[N - power - 1]
    }

    // MARK: Initializers
    public init(_ coefficients: InlineArray<N, T>) {
        self.coefficients = coefficients
    }
}

// MARK: Self: Converter
@available(macOS 26.0, *)
extension PolynomialFunction: Converter where T: ElementaryFunctions {
    public typealias Value = T

    public func baseValue(of value: Value) -> Value {
        (0..<N).reduce(.zero) { $0 + self[e: $1] * Value.pow(value, $1) }
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension PolynomialFunction: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
@available(macOS 26.0, *)
extension PolynomialFunction: ExpressibleByArrayLiteral where T: AdditiveArithmetic {
    public init(arrayLiteral elements: T...) {
        self.coefficients = .init {
            if elements.indices.contains($0) {
                elements[$0]
            } else {
                .zero
            }
        }
    }
}

// MARK: Self: Sendable
@available(macOS 26.0, *)
extension PolynomialFunction: Sendable where T: Sendable {}

// MARK: Self.N == 1
@available(macOS 26.0, *)
public typealias ConstantFunction<T: Numeric> = PolynomialFunction<1, T>

@available(macOS 26.0, *)
public extension PolynomialFunction where N == 1 {
    static var one: Self { .init([1]) }

    static func constant(_ k: T) -> Self { .init([k]) }

    func convert(_ baseValue: Value) -> Value where T: ElementaryFunctions { constant }
}

// MARK: Self.N == 2
@available(macOS 26.0, *)
public typealias LinearFunction<T: Numeric> = PolynomialFunction<2, T>

@available(macOS 26.0, *)
public extension PolynomialFunction where N == 2 {
    var coefficient: T { coefficients[0] }
    static var unit: Self { .init([1, 0]) }

    static func linear(_ a: T, k: T = 0) -> Self { .init([a, k]) }

    static func * (lhs: Self, rhs: Self) -> PolynomialFunction<3, T> {
        .quadratic(
            lhs.coefficient * rhs.coefficient,
            b: lhs.coefficient * rhs.constant + lhs.constant * rhs.coefficient,
            c: lhs.constant * rhs.constant
        )
    }
}

@available(macOS 26.0, *)
extension PolynomialFunction where N == 2, T: FloatingPoint {
    func convert(_ baseValue: Value) -> Value? where T: ElementaryFunctions {
        guard coefficient != 0 else { return nil }

        let numerator = baseValue - constant
        return numerator / coefficient
    }
}

// MARK: Self.N == 3
@available(macOS 26.0, *)
public typealias QuadraticFunction<T: Numeric> = PolynomialFunction<3, T>

@available(macOS 26.0, *)
public extension PolynomialFunction where N == 3 {
    var formalDerivative: PolynomialFunction<2, T> {
        .linear(
            self[e: 2] * 2,
            k: self[e: 1]
        )
    }

    static func quadratic(_ a: T, b: T = 0, c: T = 0) -> Self { .init([a, b, c]) }

    static func * (lhs: Self, rhs: PolynomialFunction<2, T>) -> PolynomialFunction<4, T> {
        .cubic(
            lhs[e: 2] * rhs.coefficient,
            b: lhs[e: 2] * rhs.constant + lhs[e: 1] * rhs.coefficient,
            c: lhs[e: 1] * rhs.constant + lhs[e: 0] * rhs.coefficient,
            d: lhs[e: 0] * rhs.constant
        )
    }
}

// MARK: Self.N == 4
@available(macOS 26.0, *)
public typealias CubicFunction<T: Numeric> = PolynomialFunction<4, T>

@available(macOS 26.0, *)
public extension PolynomialFunction where N == 4 {
    var formalDerivative: PolynomialFunction<3, T> {
        .quadratic(
            self[e: 3] * 3,
            b: self[e: 2] * 2,
            c: self[e: 1]
        )
    }

    static func cubic(_ a: T, b: T = 0, c: T = 0, d: T = 0) -> Self { .init([a, b, c, d]) }
}

// MARK: Self.T: Numeric
@available(macOS 26.0, *)
public extension PolynomialFunction where T: Numeric {
    static func * (lhs: Self, rhs: T) -> Self {
        .init(.init { lhs.coefficients[$0] * rhs })
    }
}

// MARK: Self.T: FloatingPoint
@available(macOS 26.0, *)
public extension PolynomialFunction where T: FloatingPoint {
    static func / (lhs: Self, rhs: T) -> Self {
        .init(.init { lhs.coefficients[$0] / rhs })
    }
}

// MARK: InlineArray (EX)
@available(macOS 26.0, *)
extension InlineArray: @retroactive Equatable where Element: Equatable {
    public static func == (lhs: InlineArray<count, Element>, rhs: InlineArray<count, Element>) -> Bool {
        for i in 0..<count {
            guard lhs[i] == rhs[i] else { return false }
        }

        return true
    }
}
