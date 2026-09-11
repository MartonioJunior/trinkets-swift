//
//  Meter+Floor.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/09/2026.
//

import MatheRange

public extension Meter where B: Floor {
    /// Instant representing the lower bound of the meter, indicating where it becomes empty.
    var floor: Instant { boundary.lowerBound }
    /// Creates a meter with a floor, starting at it's lower bound.
    /// - Parameter floor: Floor used as the reference.
    init(f floor: B) {
        self.instant = floor.lowerBound
        self.boundary = floor
    }
    /// Empties the meter up to it's lower bound, independent of boundary constraints.
    mutating func depleteAll() {
        override(to: floor)
    }
}

// MARK: Self.Instant: Comparable
public extension Meter where B: Floor, Instant: Comparable {
    /// Indicates that the meter is empty.
    /// 
    /// This occurs when the current instant is at or below the meter's lower bound.
    var isEmpty: Bool { instant <= boundary.lowerBound }
    /// Indicates that the meter is underflowing.
    /// 
    /// This occurs when the current instant is below the meter's lower bound.
    var isUnderflowing: Bool { instant < boundary.lowerBound }
    /// Depletes the meter to a given value.
    /// - Parameter newValue: Instant of meter after depletion.
    mutating func deplete(downTo newValue: Instant) {
        override(to: boundary.floor(newValue))
    }
}

// MARK: Self.Instant: Strideable
public extension Meter where B: Floor, Instant: Strideable {
    /// Interval from the current state until the floor, indicating how much meter one has.
    var filled: Instant.Stride { floor.distance(to: instant) }
    /// Checks whether you can spend a certain amount of meter.
    /// - Parameter amount: Amount to be depleted.
    /// - Returns: `true` when the meter has enough filled in it, `false` otherwise.
    func canSpend(_ amount: Instant.Stride) -> Bool {
        let distance = floor.distance(to: instant)
        return distance >= amount
    }
    /// Depletes the meter, leaving an interval between the current state and the upper bound.
    /// - Parameter amount: Interval to keep filled.
    mutating func deplete(leaving amount: Instant.Stride) {
        override(to: floor.advanced(by: amount))
    }
    /// Spends the given amount of meter.
    /// - Parameter amount: Amount of meter.
    mutating func spend(_ amount: Instant.Stride) {
        deplete(downTo: instant.advanced(by: -amount))
    }
}
