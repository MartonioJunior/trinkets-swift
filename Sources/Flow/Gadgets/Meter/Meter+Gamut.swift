//
//  Meter+Gamut.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/09/2026.
//

import MatheRange

// MARK: Self.Instant: Comparable
public extension Meter where B: Gamut, Instant: Comparable {
    /// Attempts to update the current instant in the meter, clamping it to stay within a certain range.
    /// - Parameter newValue: Instant to set the meter to.
    mutating func setInstant(clamping newValue: Instant) {
        override(to: boundary.clamp(newValue))
    }
}

// MARK: Self.Instant: Strideable
public extension Meter where B: Gamut, Instant: Strideable {
    /// Interval representing the max amount of meter.
    var capacity: Instant.Stride { floor.distance(to: ceiling) }
    /// Calculates the instant for a given percentage of meter.
    /// - Parameter percentage: Percentage of meter.
    /// - Returns: Calculated instant for `percentage`.
    func instant(atPercent percentage: Instant.Stride) -> Instant {
        floor.advanced(by: interval(forPercent: percentage))
    }
    /// Calculates the interval for a given percentage of meter.
    /// - Parameter percentage: Percentage of meter.
    /// - Returns: Calculated amount of meter for `percentage`.
    func interval(forPercent percentage: Instant.Stride) -> Instant.Stride {
        capacity * percentage
    }
    /// Performs a mutation on the meter using an instant representing a meter filled by a certain percentage of it's capacity.
    /// - Parameters:
    ///   - percentage: Percentage of it's capacity.
    ///   - setter: Mutation to be applied to the meter.
    /// - Returns: Output of the `setter` function.
    mutating func withInstant<T>(ofPercent percentage: Instant.Stride, setter: (inout Self, Instant) -> T) -> T {
        setter(&self, instant(atPercent: percentage))
    }
    /// Performs a mutation on the meter using an interval representing a certain percentage of it's capacity.
    /// - Parameters:
    ///   - percentage: Percentage of it's capacity.
    ///   - setter: Mutation to be applied to the meter.
    /// - Returns: Output of the `setter` function.
    mutating func withInterval<T>(
        ofPercent percentage: Instant.Stride,
        setter: (inout Self, Instant.Stride) -> T
    ) -> T {
        setter(&self, interval(forPercent: percentage))
    }
}
