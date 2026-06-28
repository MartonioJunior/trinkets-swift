//
//  Amount.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/11/2025.
//

/// Dynamic unit with no extra information.
@dynamicMemberLookup
public struct Amount {
    /// Symbol representing the unit.
    var symbol: String
    /// Creates a new amount category.
    /// - Parameter member: Name of the category.
    /// - Returns: A new `Amount` instance.
    @inlinable
    public static subscript(dynamicMember member: String) -> Self {
        Self.of(member)
    }
    /// Creates a new amount category.
    /// - Parameter symbol: Symbol of the type.
    public init(_ symbol: String) {
        self.symbol = symbol
    }
    /// Creates a new amount category.
    /// - Parameter string: Symbol, defined by a `StaticString`.
    /// - Returns: A new `Amount` instance.
    static func auto(_ string: StaticString = #function) -> Self { .of(string.description) }
    /// Creates a new amount category.
    /// - Parameter symbol: Name of the category.
    /// - Returns: A new `Amount` instance.
    public static func of(_ symbol: String) -> Self {
        .init(symbol)
    }
}

// MARK: Self: Quantifiable
extension Amount: Quantifiable {}

// MARK: Self: Equatable
extension Amount: Equatable {}

// MARK: Self: Sendable
extension Amount: Sendable {}
