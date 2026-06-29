//
//  ProductUnit.swift
//  Trinkets
//
//  Created by Martônio Júnior on 09/02/25.
//

/// Product between two units.
/// - A: Left-hand side unit.
/// - B: Right-hand side unit.
public struct ProductUnit<A, B> {
    /// Product that has it's factors flipped around.
    /// 
    /// This does not change the overall result of the operation, just it's type definition.
    public typealias Flipped = ProductUnit<B, A>
    // MARK: Variables
    /// Left-hand side unit.
    public var lhs: A
    /// Right-hand side unit.
    public var rhs: B
    // MARK: Initializers
    /// Creates a new unit product.
    /// - Parameters:
    ///   - lhs: An unit.
    ///   - rhs: Another unit.
    ///
    public init(_ lhs: A, _ rhs: B) where A: Quantifiable, B: Quantifiable {
        self.lhs = lhs
        self.rhs = rhs
    }
}

public extension ProductUnit where A: Quantifiable, B: Quantifiable {
    /// Flips a product around. This does not change the overall result of the operation, just it's type definition.
    var flipped: Flipped { .init(rhs, lhs) }
}

// MARK: Self: Convertible
extension ProductUnit: Convertible where A: Convertible, B: Convertible {
    // swiftlint:disable:next missing_docs
    public typealias Base = ProductUnit<A.Base, B.Base>
}

// MARK: Self: CustomStringConvertible
extension ProductUnit: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { "\(lhs)-\(rhs)" }
}

// MARK: Self: Domain
extension ProductUnit: Domain {
    // swiftlint:disable:next missing_docs
    public typealias Symbol = String
}

// MARK: Self: Dimension
extension ProductUnit: Dimension where A: Dimension, B: Dimension {
    // swiftlint:disable:next missing_docs
    public typealias BaseUnit = ProductUnit<A.BaseUnit, B.BaseUnit>
    // swiftlint:disable:next missing_docs
    public static var dimensionality: Dimensionality { A.dimensionality + B.dimensionality }
}

// MARK: Self: Equatable
extension ProductUnit: Equatable where A: Equatable, B: Equatable {}

// MARK: Self: Hashable
extension ProductUnit: Hashable where A: Hashable, B: Hashable {}

// MARK: Self: Quantifiable
extension ProductUnit: Quantifiable where A: Quantifiable, B: Quantifiable {}

// MARK: Self: Sendable
extension ProductUnit: Sendable where A: Sendable, B: Sendable {}

// MARK: Self: SendableMetatype
extension ProductUnit: SendableMetatype {}

// MARK: Self: StaticUnit
extension ProductUnit: StaticUnit where A: StaticUnit, B: StaticUnit {}

// MARK: Measurement (EX)
public extension Measurement where UnitType: Quantifiable, Value: Numeric {
    /// Multiplies the measure with another.
    /// - Parameter other: A measurement.
    /// - Returns: A new `Measurement` with the product of quantities associated to a `Product` of units.
    func multiply<T: Quantifiable>(by other: Measurement<T, Value>) -> Measurement<ProductUnit<UnitType, T>, Value> {
        .init(value * other.value, .init(unit, other.unit))
    }
    /// Multiplies the measure with another.
    /// - Parameters:
    ///   - lhs: A measurement.
    ///   - rhs: Another measurement.
    /// - Returns: A new `Measurement` with the product of quantities associated to a `Product` of units.
    static func * <T: Quantifiable>(lhs: Self, rhs: Measurement<T, Value>) -> Measurement<ProductUnit<UnitType, T>, Value> {
        lhs.multiply(by: rhs)
    }
}
