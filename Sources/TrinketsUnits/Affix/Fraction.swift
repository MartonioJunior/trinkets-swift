//
//  Fraction.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

public struct Fraction<A: Domain, B: Domain> {
    // MARK: Aliases
    public typealias Flipped = Fraction<B, A>

    // MARK: Variables
    public var numerator: Unit<A>
    public var denominator: Unit<B>

    public var asUnit: Unit<Self> { .init(self) }
    public var flipped: Flipped { .init(denominator, per: numerator) }

    // MARK: Initializers
    public init(_ numerator: Unit<A>, per denominator: Unit<B>) {
        self.numerator = numerator
        self.denominator = denominator
    }
}

// MARK: Self: CustomStringConvertible
extension Fraction: CustomStringConvertible {
    public var description: String {
        "\(numerator)/\(denominator)"
    }
}

// MARK: Self: Domain
extension Fraction: Domain {
    public typealias Features = Self
}

// MARK: Self: Dimension
extension Fraction: Dimension & Measurable where A: Dimension, B: Dimension, A.Value == B.Value, A.Value: FloatingPoint {
    public typealias Value = A.Value

    public static var baseUnit: Self.Unit { A.baseUnit / B.baseUnit }
    public static var dimensionality: Dimensionality { A.dimensionality - B.dimensionality }

    public static func baseValue(of value: Value, _ unit: Self.Unit) -> Value {
        A.baseValue(of: value, unit.features.numerator) / B.baseValue(of: 1, unit.features.denominator)
    }

    public static func convert(_ baseValue: Value, to unit: Self.Unit) -> Value {
        A.convert(B.baseValue(of: baseValue, unit.features.denominator), to: unit.features.numerator)
    }
}

// MARK: Self: Equatable
extension Fraction: Equatable where A.Features: Equatable, B.Features: Equatable {}

// MARK: Self: Hashable
extension Fraction: Hashable where A.Features: Hashable, B.Features: Hashable {}

// MARK: Self: Sendable
extension Fraction: Sendable where A.Features: Sendable, B.Features: Sendable {}

// MARK: Unit (EX)
public extension Unit {
    @inlinable
    init<A: Domain, B: Domain>(_ numerator: Unit<A>, per denominator: Unit<B>) where D == Fraction<A, B> {
        self.init(Fraction(numerator, per: denominator))
    }

    @inlinable
    init<A: Domain, B: Domain>(_ fraction: Fraction<A, B>) where D == Fraction<A, B> {
        self.init(fraction.description, details: fraction)
    }

    @inlinable
    func per<E: Domain>(_ denominator: Unit<E>) -> Unit<Fraction<D, E>> {
        self / denominator
    }

    static func / <E: Domain>(lhs: Self, rhs: Unit<E>) -> Unit<Fraction<D, E>> {
        .init("\(lhs.symbol)/\(rhs.symbol)", details: .init(lhs, per: rhs))
    }
}
