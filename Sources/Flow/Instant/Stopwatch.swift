//
//  Stopwatch.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/07/2026.
//

/// Data structure that accumulates intervals together.
/// - Interval: Progress from the initial state to the current one.
public struct Stopwatch<Interval> {
    // MARK: Variables
    /// Accumulated sum of intervals.
    var elapsed: Interval
    // MARK: Initializers
    /// Creates a new stopwatch.
    /// - Parameter elapsed: Accumulated sum of intervals.
    public init(elapsed: Interval) {
        self.elapsed = elapsed
    }
    // MARK: Methods
    /// Calculates the current instant based on a given calendar.
    /// - Parameters:
    ///   - calendar: Calendar used as the reference
    ///
    /// - Returns: Current instant for the stopwatch.
    func instant<Instant: Strideable>(
        basedOn calendar: Calendar<Instant>
    ) -> Instant where Instant.Stride == Interval {
        calendar.epoch.advanced(by: elapsed)
    }
    /// Calculates the current instant based on a given calendar.
    /// - Parameters:
    ///   - calendar: Calendar used as the reference.
    ///   - delta: Formula used for offsetting the instant.
    ///
    /// - Returns: Current instant for the stopwatch.
    func instant<Instant>(
        basedOn calendar: Calendar<Instant>,
        delta: (Instant, Interval) -> Instant
    ) -> Instant {
        delta(calendar.epoch, elapsed)
    }
    /// Calculates the remaining interval until reaching an instant based on a calendar.
    /// - Parameters:
    ///   - calendar: Calendar used as the reference.
    ///   - instant: Target instant.
    ///
    /// - Returns: Interval left to get to an instant.
    func remaining<Instant: Strideable>(
        from calendar: Calendar<Instant>,
        until instant: Instant
    ) -> Interval where Instant.Stride == Interval {
        calendar.intervalSinceEpoch(for: instant) - elapsed
    }
}

// MARK: Self: Equatable
extension Stopwatch: Equatable where Interval: Equatable {}

// MARK: Self: Sendable
extension Stopwatch: Sendable where Interval: Sendable {}

// MARK: Self.Interval: AdditiveArithmetic
public extension Stopwatch where Interval: AdditiveArithmetic {
    /// Advances the elapsed state by a given internal.
    /// - Parameters:
    ///   - interval: Interval to be added.
    mutating func advance(by interval: Interval) {
        elapsed += interval
    }
    /// Calculates the remaining interval until reaching an instant based on a calendar.
    /// - Parameters:
    ///   - calendar: Calendar used as the reference.
    ///   - instant: Target instant.
    ///   - distance: Formula used to calculate the distance between instants.
    ///
    /// - Returns: Interval left to get to an instant.
    func remaining<Instant>(
        from calendar: Calendar<Instant>,
        until instant: Instant,
        distance: (Instant, Instant) -> Interval
    ) -> Interval {
        calendar.intervalSinceEpoch(for: instant, distance) - elapsed
    }
}
