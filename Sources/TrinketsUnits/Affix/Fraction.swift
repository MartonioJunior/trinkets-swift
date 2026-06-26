//
//  Fraction.swift
//  Trinkets
//
//  Created by Martônio Júnior on 09/02/25.
//

/// Division between two units.
/// - A: Numerator unit.
/// - B: Denominator unit.
public struct Fraction<A, B> {
    /// Fraction that swaps numerator and denominator types around.
    public typealias Flipped = Fraction<B, A>
    // MARK: Variables
    /// Numerator unit.
    public var numerator: A
    /// Denominator unit.
    public var denominator: B
    // MARK: Initializers
    /// Creates a new unit fraction.
    /// - Parameters:
    ///   - numerator: Unit on top.
    ///   - denominator: Unit on bottom.
    ///
    public init(_ numerator: A, per denominator: B) where A: Measurable, B: Measurable {
        self.numerator = numerator
        self.denominator = denominator
    }
}

public extension Fraction where A: Measurable, B: Measurable {
    /// Fraction that swaps numerator and denominator around.
    var flipped: Flipped { .init(denominator, per: numerator) }
}

// MARK: Self: Convertible
extension Fraction: Convertible where A: Convertible, B: Convertible {
    // swiftlint:disable:next missing_docs
    public typealias Base = Fraction<A.Base, B.Base>
}

// MARK: Self: CustomStringConvertible
extension Fraction: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { "\(numerator)/\(denominator)" }
}

// MARK: Self: Domain
extension Fraction: Domain where A: Domain, B: Domain {
    // swiftlint:disable:next missing_docs
    public typealias Symbol = String
}

// MARK: Self: Dimension
extension Fraction: Dimension where A: Dimension, B: Dimension {
    // swiftlint:disable:next missing_docs
    public typealias BaseUnit = Fraction<A.BaseUnit, B.BaseUnit>
    // swiftlint:disable:next missing_docs
    public static var dimensionality: Dimensionality { A.dimensionality - B.dimensionality }
}

// MARK: Self: Equatable
extension Fraction: Equatable where A: Equatable, B: Equatable {}

// MARK: Self: Measurable
extension Fraction: Measurable where A: Measurable, B: Measurable {}

// MARK: Self: Hashable
extension Fraction: Hashable where A: Hashable, B: Hashable {}

// MARK: Self: Sendable
extension Fraction: Sendable where A: Sendable, B: Sendable {}

// MARK: Self: Sendable
extension Fraction: SendableMetatype {}

// MARK: Self: StaticUnit
extension Fraction: StaticUnit where A: StaticUnit, B: StaticUnit {}

// MARK: Measurement (EX)
public extension Measurement where UnitType: Measurable, Value: FloatingPoint {
    /// Divides a measure by another.
    /// - Parameter denominator: Divisor measurement.
    /// - Returns: A new `Measurement` with the division of quantities associated to a `Fraction` of units.
    func per<T: Measurable>(_ denominator: Measurement<T, Value>) -> Measurement<Fraction<UnitType, T>, Value> {
        .init(value / denominator.value, .init(unit, per: denominator.unit))
    }
    /// Divides a measure by another.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Divisor measurement.
    /// - Returns: A new `Measurement` with the division of quantities associated to a `Fraction` of units.
    static func / <T: Measurable>(lhs: Self, rhs: Measurement<T, Value>) -> Measurement<Fraction<UnitType, T>, Value> {
        lhs.per(rhs)
    }
}
