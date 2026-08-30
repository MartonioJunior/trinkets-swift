//
//  Timing.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2026.
//

import MatheRange
/// Data structure that defines the leniency parameters for using an element in relation to the current state.
public struct Timing<Interval> {
    /// Minimum interval that an activation can be buffered from recovery.
    /// 
    /// Setting this to a negative value turns it into a delayed activation.
    var carry: Interval
    /// Grace interval offered to perform an activation.
    /// 
    /// Setting this to a negative value turns it into an earlier expiration.
    var coyote: Interval
    // MARK: Initializers
    /// Creates a new timing window.
    /// - Parameters:
    ///   - carry: Minimum interval to carry over.
    ///   - coyote: Grace period to perform an activation.
    ///
    public init(
        carry: Interval,
        coyote: Interval
    ) {
        self.carry = carry
        self.coyote = coyote
    }
    // MARK: Methods
    /// Indicates the expiration of a grace period.
    /// - Parameters:
    ///   - instant: Instant where the grace period starts.
    /// - Returns: Instant of the expiration.
    func expiration<Instant: Strideable>(
        startingFrom instant: Instant
    ) -> Instant where Instant.Stride == Interval {
        instant.advanced(by: coyote)
    }
    /// Indicates the expiration of a grace period.
    /// - Parameters:
    ///   - instant: Instant where the grace period starts.
    ///   - delta: Formula used for offsetting the instant.
    /// - Returns: Instant of the expiration.
    func expiration<Instant>(
        startingFrom instant: Instant,
        delta: (Instant, Interval) -> Instant
    ) -> Instant {
        delta(instant, coyote)
    }
    /// Defines a Quick-Time Event (QTE).
    /// - Parameters:
    ///   - instant: Start instant of the quick-time event.
    /// - Returns: Window of activation for a quick-time event.
    /// 
    /// Activating after this window results in a late miss.
    func quickTimeEvent<Instant: Strideable>(
        startingFrom instant: Instant
    ) -> PartialRangeThrough<Instant> where Instant.Stride == Interval {
        ...expiration(startingFrom: instant)
    }
    /// Defines a Quick-Time Event (QTE).
    /// - Parameters:
    ///   - instant: Start instant of the quick-time event.
    ///   - delta: Formula used for offsetting the start instant.
    /// - Returns: Window of activation for a quick-time event.
    /// 
    /// Activating after this window results in a late miss.
    func quickTimeEvent<Instant>(
        startingFrom instant: Instant,
        delta: (Instant, Interval) -> Instant
    ) -> PartialRangeThrough<Instant> {
        ...expiration(startingFrom: instant, delta: delta)
    }
    /// Calculates the timing window for a given instant.
    /// - Parameter instant: Reference instant.
    /// - Returns: Timing window for an activation, `nil` when the window is malformed or
    /// impossible to be activated (i.e. when the start instant is after the end instant)
    func window<Instant: Strideable>(
        at instant: Instant
    ) -> ClosedRange<Instant>? where Instant.Stride == Interval {
        let start = instant.advanced(by: -carry)
        let end = instant.advanced(by: coyote)

        guard start <= end else { return nil }

        return .init(from: start, to: end)
    }
}

// MARK: Self: Equatable
extension Timing: Equatable where Interval: Equatable {}

// MARK: Self: Sendable
extension Timing: Sendable where Interval: Sendable {}

// MARK: Self.Interval: AdditiveArithmetic
public extension Timing where Interval: AdditiveArithmetic {
    /// Timing with no recovery or timing windows.
    static var zero: Self { .init(carry: .zero, coyote: .zero) }
    /// Calculates the timing window for a given gamut.
    /// - Parameter gamut: Gamut used as the base.
    /// - Returns: Range window for a trigger.
    func window<G: Gamut>(gamut: G) -> G? where G.Bound == Interval, Interval: Comparable {
        let start = gamut.lowerBound - carry
        let end = gamut.upperBound + coyote

        guard start <= end else { return nil }

        return .init(from: start, to: end)
    }
}

// MARK: Self.Interval: SignedNumeric
public extension Timing where Interval: SignedNumeric {
    /// Calculates the timing window for a given instant.
    /// - Parameters:
    ///   - instant: Reference instant.
    ///   - delta: Formula used for offsetting the instant.
    /// - Returns: Timing window for an activation, `nil` when the window is malformed or
    /// impossible to be activated (i.e. when the start instant is after the end instant)
    func window<Instant>(
        at instant: Instant,
        delta: (Instant, Interval) -> Instant
    ) -> ClosedRange<Instant>? {
        let start = delta(instant, -carry)
        let end = delta(instant, coyote)

        guard start <= end else { return nil }

        return .init(from: start, to: end)
    }
}
