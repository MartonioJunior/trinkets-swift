//
//  Exponential.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/06/2025.
//

@available(macOS 26.0, *)
public struct Exponential<D: Domain, let N: Int> {
    // MARK: Variables
    public var unit: Unit<D>
    public var exponent: Int { N }

    // MARK: Initializers
    public init(_ unit: Unit<D>) {
        self.unit = unit
    }
}

// MARK: N == 0
@available(macOS 26.0, *)
public typealias Unitless<D: Domain> = Exponential<D, 0>

// MARK: N == 1
@available(macOS 26.0, *)
public typealias Linear<D: Domain> = Exponential<D, 1>

@available(macOS 26.0, *)
public extension Exponential where N == 1 {}

// MARK: N == 2
@available(macOS 26.0, *)
public typealias Square<D: Domain> = Exponential<D, 2>

@available(macOS 26.0, *)
public extension Exponential where N == 2 {
    static var symbol: String { "²" }
}

// MARK: N == 3
@available(macOS 26.0, *)
public typealias Cubic<D: Domain> = Exponential<D, 3>

@available(macOS 26.0, *)
public extension Exponential where N == 3 {
    static var symbol: String { "³" }
}

// MARK: Self: CustomStringConvertible
@available(macOS 26.0, *)
extension Exponential: CustomStringConvertible {
    public var description: String {
        "\(unit)^\(N)"
    }
}

// MARK: Self: Domain
@available(macOS 26.0, *)
extension Exponential: Domain {
    public typealias Features = Self
}

// MARK: Self: Dimension
@available(macOS 26.0, *)
extension Exponential: Dimension, Measurable where D: Dimension, D.Value == Double {
    public typealias Value = D.Value

    public static var baseUnit: Self.Unit { D.baseUnit.pow() }
    public static var dimensionality: Dimensionality { D.dimensionality * N }

    public static func baseValue(of value: Value, _ unit: Self.Unit) -> Value {
        Value.pow(D.baseValue(of: value, unit.features.unit), N)
    }

    public static func convert(_ baseValue: Value, to unit: Self.Unit) -> Value {
        D.convert(Value.root(baseValue, N), to: unit.features.unit)
    }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension Exponential: Equatable where D.Features: Equatable, D.Symbol: Equatable {}

// MARK: Self: Sendable
@available(macOS 26.0, *)
extension Exponential: Sendable where D.Features: Sendable, D.Symbol: Sendable {}

@available(macOS 26.0, *)
public extension Domain {
    typealias E<let N: Int> = Exponential<Self, N>
}

// MARK: Unit (EX)
@available(macOS 26.0, *)
public extension Unit {
    var squared: Unit<Square<D>> { .square(self) }

    init<E: Domain, let N: Int>(e exponential: D) where D == Exponential<E, N> {
        self.init(exponential.description, details: exponential)
    }

    static func square<E: Domain>(_ unit: Unit<E>) -> Self where D == Square<E> {
        .init("\(unit.symbol)\(D.symbol)", details: .init(unit))
    }

    static func cubic<E: Domain>(_ unit: Unit<E>) -> Self where D == Cubic<E> {
        .init("\(unit.symbol)\(D.symbol)", details: .init(unit))
    }

    func pow<let N: Int>() -> Unit<Exponential<D, N>> { .init(e: .init(self)) }
    func inlined<E: Domain>() -> Unit<E> where D == Linear<E> { features.unit }
}
