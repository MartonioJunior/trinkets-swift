//
//  ToggleMask.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/09/2026.
//

import MatheRange
/// Infinite boundary that can be toggled on or off at will.
public struct ToggleMask<Bound> {
    // MARK: Variables
    /// Is the boundary currently active?
    var isActive: Bool
    // MARK: Initializers
    /// Creates a new toggle mask.
    /// - Parameter isActive: Is the boundary currently active?
    public init(_ isActive: Bool, _: Bound.Type = Bound.self) {
        self.isActive = isActive
    }
}

// MARK: Self: Boundary
extension ToggleMask: Boundary {
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, _: Bound) -> Bool { lhs.isActive }
}

// MARK: Self: ExpressibleByBooleanLiteral
extension ToggleMask: ExpressibleByBooleanLiteral {
    // swiftlint:disable:next missing_docs
    public init(booleanLiteral value: Bool) {
        self.isActive = value
    }
}

// MARK: Self: Equatable
extension ToggleMask: Equatable {}

// MARK: Self: Sendable
extension ToggleMask: Sendable {}
