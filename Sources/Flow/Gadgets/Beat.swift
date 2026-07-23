//
//  Beat.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/07/2026.
//

import MatheRange
/// Short-hand alias for `Beat` based on a `Strideable` instant.
public typealias BeatOf<Instant: Strideable> = Beat<Instant, Instant.Stride>
/// Rhythmic unit representing the activation timing window for a given instant. 
public struct Beat<Instant: Comparable, Interval> {
    // MARK: Variables
    /// Reference point of this beat.
    var calendar: Calendar<Instant>
    /// Timing window for this beat.
    var timing: Timing<Interval>
    // MARK: Initializers
    /// Creates a new beat.
    /// - Parameters:
    ///   - calendar: Reference point of this beat.
    ///   - timing: Timing window for this beat.
    public init(_ calendar: Calendar<Instant>, timing: Timing<Interval>) {
        self.calendar = calendar
        self.timing = timing
    }
    // MARK: Methods
    /// Indicates when the next beat can happen after a successful activation.
    /// - Parameters:
    ///   - activation: Instant where it was last consumed.
    ///   - delta: Formula used for offsetting the instant.
    /// - Returns: Next beat.
    func nextBeat(
        after activation: Instant,
        delta: (Instant, Interval) -> Instant
    ) -> Self {
        .init(.init(epoch: timing.recovery(after: activation, delta: delta)), timing: timing)
    }
}

// MARK: Self: Comparable
extension Beat: Comparable where Instant: Comparable, Interval: Equatable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.calendar < rhs.calendar
    }
}

// MARK: Self: Equatable
extension Beat: Equatable where Instant: Equatable, Interval: Equatable {}

// MARK: Self: Selectable
extension Beat: Selectable where Instant: Comparable {
    // swiftlint:disable:next missing_docs
    public func canBeSelected(by selection: ClosedRange<Instant>) -> Bool {
        selection.contains(calendar.epoch)
    }
}

// MARK: Self: Sendable
extension Beat: Sendable where Instant: Sendable, Interval: Sendable {}

// MARK: Self: Strideable
extension Beat: Strideable where Instant: Strideable, Instant.Stride == Interval {
    // swiftlint:disable:next missing_docs
    public func advanced(by n: Interval) -> Self {
        .init(calendar.advanced(by: n), timing: timing)
    }
    // swiftlint:disable:next missing_docs
    public func distance(to other: Self) -> Interval {
        calendar.distance(to: other.calendar)
    }
}

// MARK: Self.Instant: Strideable
public extension Beat where Instant: Strideable, Instant.Stride == Interval {
    /// Timing window for this beat (when it exists).
    var window: ClosedRange<Instant>? { timing.window(at: calendar.epoch) }
    /// Checks whether a beat can be activated at the given instant.
    /// - Parameters:
    ///   - instant: Instant of activation.
    /// - Returns: `true` when the beat can be triggered, `false` otherwise.
    func canTrigger(at instant: Instant) -> Bool {
        timing.window(at: calendar.epoch)?.contains(instant) ?? false
    }
    /// Indicates when the next beat can happen after an activation.
    /// - Parameter instant: Instant where it was last consumed.
    /// - Returns: Next beat.
    func nextBeat(after instant: Instant) -> Self {
        .init(.init(epoch: timing.recovery(after: instant)), timing: timing)
    }
}

// MARK: Self.Interval: SignedNumeric
public extension Beat where Interval: SignedNumeric, Instant: Comparable {
    /// Checks whether a beat can be activated at the given instant.
    /// - Parameters:
    ///   - instant: Instant of activation.
    ///   - delta: Formula used for offsetting the instant.
    /// - Returns: `true` when the beat can be triggered, `false` otherwise.
    func canTrigger(
        at instant: Instant,
        delta: (Instant, Interval) -> Instant
    ) -> Bool {
        guard let window = timing.window(at: calendar.epoch, delta: delta) else { return false }

        return window.contains(instant)
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Filters the beats that could be activated by a given instant.
    /// - Parameter instant: Instant of activation.
    /// - Returns: Beats that can be activated at `instant`.
    func beats<Instant: Strideable>(
        triggerableAt instant: Instant
    ) -> [Element] where Element == BeatOf<Instant> {
        filter { $0.window?.contains(instant) ?? false }
    }
}
