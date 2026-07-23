//
//  BoundaryOfOne.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2026.
//

import MatheRange
/// Boundary that is represented by a single value.
/// - Instant: Infinitesimal interval whose passage is instantaneous and represents the entire boundary.
public struct BoundaryOfOne<Instant: Equatable> {
    // MARK: Variables
    /// Infinitesimal interval that acts as a boundary of one value.
    var instant: Instant
    // MARK: Initializers
    /// Creates a new boundary of one value.
    /// - Parameter instant: Infinitesimal interval that acts as a boundary of one value.
    public init(_ instant: Instant) {
        self.instant = instant
    }
}

// MARK: Self: Boundary
extension BoundaryOfOne: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = Instant
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Instant) -> Bool {
        lhs.instant == rhs
    }
}

// MARK: Self: Equatable
extension BoundaryOfOne: Equatable {}

// MARK: Self: Sendable
extension BoundaryOfOne: Sendable where Instant: Sendable {}
