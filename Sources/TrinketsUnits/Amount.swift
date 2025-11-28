//
//  Amount.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/11/2025.
//

@dynamicMemberLookup
public enum Amount {
    @inlinable
    public static subscript(dynamicMember member: String) -> Unit<Self> {
        Self.of(member)
    }

    @inlinable
    public static func of(_ symbol: Symbol) -> Unit<Self> {
        .init(symbol)
    }
}

// MARK: Self: Domain
extension Amount: Dimension {
    public typealias Features = Void

    public static var baseUnit: Unit<Self> { Unit("units") }
    public static var dimensionality: Dimensionality { .dimensionless }

    public static func baseValue(of value: Double, _: Unit<Self>) -> Double { value }
    public static func convert(_: Double, to _: Unit<Self>) -> Double { .nan }
}

// MARK: Self: Equatable
extension Amount: Equatable {}

// MARK: Self: Sendable
extension Amount: Sendable {}

// MARK: Unit (EX)
public extension Unit where D == Amount {
    static func auto(_ string: StaticString = #function) -> Self { Amount.of(string.description) }
}
