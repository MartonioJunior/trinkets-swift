//
//  Meter+Ceiling.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/09/2026.
//

import MatheRange

// MARK: Self.B: Ceiling
public extension Meter where B: Ceiling {
    /// Instant representing the upper bound of the meter, indicating where it becomes full.
    var ceiling: Instant { boundary.upperBound }
    /// Creates a meter with a ceiling, starting at it's upper bound.
    /// - Parameter ceiling: Ceiling used as the reference.
    init(c ceiling: B) {
        self.instant = ceiling.upperBound
        self.boundary = ceiling
    }
    /// Fills the meter up to it's upper bound, independent of boundary constraints.
    mutating func fill() {
        override(to: ceiling)
    }
}

public extension Meter where B: Ceiling, Instant: Comparable {
    /// Indicates that the meter is full.
    /// 
    /// This occurs when the current instant is at or above the meter's upper bound.
    var isFull: Bool { instant >= ceiling }
    /// Indicates that the meter is overflowing.
    /// 
    /// This occurs when the current instant has already passed the meter's upper bound.
    var isOverflowing: Bool { instant > ceiling }
    /// Fills the meter until the minimum between the current ceiling and the new instant.
    /// - Parameter newValue: Instant to fill the meter.
    mutating func fill(upThrough newValue: Instant) {
        override(to: boundary.ceil(newValue))
    }
}

public extension Meter where B: Ceiling, Instant: Strideable {
    /// Interval from the current state until the meter's ceiling.
    var remaining: Instant.Stride { instant.distance(to: ceiling) }
    /// Refills the meter, leaving an interval between the current state and the upper bound.
    /// - Parameter amount: Interval to keep empty.
    mutating func fill(leaving amount: Instant.Stride) {
        override(to: ceiling.advanced(by: -amount))
    }
    /// Fills the meter by a given amount.
    /// - Parameter amount: Interval to advance to the meter.
    mutating func fill(by amount: Instant.Stride) {
        fill(upThrough: instant.advanced(by: amount))
    }
}
