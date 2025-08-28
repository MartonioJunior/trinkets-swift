//
//  Unit.swift
//  Trinkets
//
//  Created by Martônio Júnior on 09/02/25.
//

public struct Unit<D: Domain> {
    // MARK: Variables
    /// Symbol associated with the unit
    public private(set) var symbol: D.Symbol
    /// Set of parameters that defines the unit
    public private(set) var features: D.Features
    // MARK: Initializers
    /// Creates a new unit based on a symbol and a set of features
    /// - Parameters:
    ///   - symbol: Symbol associated with the unit
    ///   - details: Parameters that define the unit
    ///
    public init(
        _ symbol: D.Symbol,
        details: D.Features
    ) {
        self.symbol = symbol
        self.features = details
    }
}

// MARK: Self: Codable
extension Unit: Codable where D.Features: Codable, D.Symbol: Codable {}

// MARK: Self: Comparable
extension Unit: Comparable where D.Features: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.features < rhs.features
    }
}

// MARK: Self: CustomStringConvertible
extension Unit: CustomStringConvertible where D.Symbol: CustomStringConvertible {
    public var description: String { symbol.description }
}

// MARK: Self: Equatable
extension Unit: Equatable where D.Features: Equatable, D.Symbol: Equatable {}

// MARK: Self: Hashable
extension Unit: Hashable where D.Features: Hashable, D.Symbol: Hashable {}

// MARK: Self: Sendable
extension Unit: Sendable where D.Features: Sendable, D.Symbol: Sendable {}

// MARK: D.Features == Void
public extension Unit where D.Features == Void {
    init(_ symbol: D.Symbol) {
        self.symbol = symbol
        self.features = ()
    }
}
