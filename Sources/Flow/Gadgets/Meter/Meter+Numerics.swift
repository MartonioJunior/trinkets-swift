//
//  Meter+Numerics.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/09/2026.
//

#if canImport(Numerics)
import MatheRange
import Numerics

public extension Meter where B: Gamut, Instant: Strideable, Instant.Stride: AlgebraicField {
    /// Calculates the percentage of meter filled at a given instant.
    /// - Parameter instant: Instant of reference.
    /// - Returns: Percentage of meter filled.
    func percentageFilled(at instant: Instant) -> Instant.Stride {
        floor.distance(to: instant) / capacity
    }
    /// Calculates the percentage of meter remaining to be filled at a given instant.
    /// - Parameter instant: Instant of reference.
    /// - Returns: Percentage of meter remaining to be filled.
    func percentageRemaining(at instant: Instant) -> Instant.Stride {
        instant.distance(to: ceiling) / capacity
    }
}
#endif
