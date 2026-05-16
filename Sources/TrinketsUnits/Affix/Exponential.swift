//
//  Exponential.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/06/2025.
//

/// Modifier that negates a unit's dimensionality.
@available(macOS 26.0, *)
public typealias Unitless<T> = Exponential<T, 0>
/// Modifier that keeps an unit as is.
@available(macOS 26.0, *)
public typealias Linear<T> = Exponential<T, 1>
/// Modifier that elevates a unit to it's second power.
@available(macOS 26.0, *)
public typealias Square<T> = Exponential<T, 2>
/// Modifier that elevates a unit to it's third power.
@available(macOS 26.0, *)
public typealias Cubic<T> = Exponential<T, 3>

/// Modifier that applies a power to a given unit.
/// - T: Type representing the unit.
/// - N: Exponent it is raised to.
@available(macOS 26.0, *)
public struct Exponential<T, let N: Int> {
    // MARK: Variables
    /// Unit used as the base.
    public var base: T
    /// Power it was raised to.
    public var exponent: Int { N }
    // MARK: Initializers
    /// Creates a new exponential instance with a base unit.
    /// - Parameter base: Dynamic unit.
    public init(_ base: T) where T: Measurable {
        self.base = base
    }
}

// MARK: Self: Convertible
@available(macOS 26.0, *)
extension Exponential: Convertible where T: Convertible {
    // swiftlint:disable:next missing_docs
    public typealias Base = Exponential<T.Base, N>
}

// MARK: Self: CustomStringConvertible
@available(macOS 26.0, *)
extension Exponential: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { "\(base)^\(N)" }
}

// MARK: Self: Domain
@available(macOS 26.0, *)
extension Exponential: Domain where T: Domain {
    // swiftlint:disable:next missing_docs
    public typealias Symbol = String
}

// MARK: Self: Dimension
@available(macOS 26.0, *)
extension Exponential: Dimension where T: Dimension {
    // swiftlint:disable:next missing_docs
    public typealias BaseUnit = Exponential<T.BaseUnit, N>
    // swiftlint:disable:next missing_docs
    public static var dimensionality: Dimensionality { T.dimensionality * N }
}

// MARK: Self: Equatable
@available(macOS 26.0, *)
extension Exponential: Equatable where T: Equatable {}

// MARK: Self: Measurable
@available(macOS 26.0, *)
extension Exponential: Measurable where T: Measurable {}

// MARK: Self: Sendable
@available(macOS 26.0, *)
extension Exponential: Sendable where T: Sendable {}

// MARK: Self: SendableMetatype
@available(macOS 26.0, *)
extension Exponential: SendableMetatype {}

// MARK: Self: StaticUnit
@available(macOS 26.0, *)
extension Exponential: StaticUnit where T: StaticUnit {}

// MARK: Measurable (EX)
@available(macOS 26.0, *)
public extension Measurable {
    /// Short alias for an exponential unit.
    typealias E<let N: Int> = Exponential<Self, N>
    /// Squared version of the unit.
    var squared: Exponential<Self, 2> { .init(self) }
    /// Cubic version of the unit.
    var cubic: Exponential<Self, 3> { .init(self) }
}
