//
//  Combined.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

public struct Product<A: Domain, B: Domain> {
    public typealias Flipped = Product<B, A>

    // MARK: Variables
    public var lhs: Unit<A>
    public var rhs: Unit<B>

    public var asUnit: Unit<Self> { .init(self) }
    public var flipped: Flipped { .init(rhs, lhs) }

    // MARK: Initializers
    public init(_ lhs: Unit<A>, _ rhs: Unit<B>) {
        self.lhs = lhs
        self.rhs = rhs
    }
}

// MARK: Self: CustomStringConvertible
extension Product: CustomStringConvertible {
    public var description: String {
        "\(lhs)-\(rhs)"
    }
}

// MARK: Self: Domain
extension Product: Domain {
    public typealias Features = Self
}

// MARK: Self: Dimension
extension Product: Dimension, Measurable where A: Dimension, B: Dimension, A.Value == B.Value, A.Value: Numeric {
    public typealias Value = A.Value

    public static var baseUnit: Self.Unit { A.baseUnit * B.baseUnit }
    public static var dimensionality: Dimensionality { A.dimensionality + B.dimensionality }

    public static func baseValue(of value: Value, _ unit: Self.Unit) -> Value {
        A.baseValue(of: value, unit.features.lhs) * B.baseValue(of: 1, unit.features.rhs)
    }

    public static func convert(_ baseValue: Value, to unit: Self.Unit) -> Value {
        A.convert(B.convert(baseValue, to: unit.features.rhs), to: unit.features.lhs)
    }
}

// MARK: Self: Equatable
extension Product: Equatable where A.Features: Equatable, B.Features: Equatable {}

// MARK: Self: Hashable
extension Product: Hashable where A.Features: Hashable, B.Features: Hashable {}

// MARK: Self: Sendable
extension Product: Sendable where A.Features: Sendable, B.Features: Sendable {}

// MARK: Unit (EX)
public extension Unit {
    @inlinable
    init<A: Domain, B: Domain>(_ lhs: Unit<A>, _ rhs: Unit<B>) where D == Product<A, B> {
        self.init(Product(lhs, rhs))
    }

    @inlinable
    init<A: Domain, B: Domain>(_ product: Product<A, B>) where D == Product<A, B> {
        self.init(product.description, details: product)
    }

    @inlinable
    func callAsFunction<E: Domain>(_ rhs: Unit<E>) -> Unit<Product<D, E>> {
        self * rhs
    }

    @inlinable
    static func * <E: Domain>(lhs: Self, rhs: Unit<E>) -> Unit<Product<D, E>> {
        .init("\(lhs.symbol)-\(rhs.symbol)", details: .init(lhs, rhs))
    }
}
