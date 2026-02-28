//
//  Calendar.swift
//  Trinkets
//
//  Created by Martônio Júnior on 03/01/2026.
//

/// System by which the beginning, length, and subdivisions are fixed.
/// 
/// Works as a reference point to which all stamps, instants and intervals can derive themselves from.
/// - Instant: Infinitesimal interval whose passage is instantaneous.
public struct Calendar<Instant: Comparable> {
    // MARK: Variables
    /// Reference instant representing the starting point used by this calendar.
    var epoch: Instant
    // MARK: Initializers
    /// Creates a new calendar.
    /// - Parameter epoch: Reference instant representing the starting point.
    public init(epoch: Instant) {
        self.epoch = epoch
    }
    // MARK: Methods
    /// Interval between an instant and it's epoch.
    /// - Parameters:
    ///   - instant: Current instant.
    ///   - distance: Distance function.
    /// - Returns: Interval between `epoch` and the current `instant`.
    func intervalSinceEpoch<Interval>(
        for instant: Instant,
        _ distance: (Instant, Instant) -> Interval
    ) -> Interval {
        distance(epoch, instant)
    }
    /// Range of activity for a given interval.
    /// - Parameters:
    ///   - interval: Interval that composes the range.
    ///   - delta: Formula used for offsetting the instant.
    ///
    /// - Returns: Closed range starting at the epoch with the distance of `interval` until it's upper-bound,
    /// `nil` when the new instant is before this epoch.
    func range<Interval>(
        after interval: Interval,
        delta: (Instant, Interval) -> Instant
    ) -> ClosedRange<Instant>? {
        let newInstant = delta(epoch, interval)

        if newInstant < epoch { return nil }

        return .init(from: epoch, to: delta(epoch, interval))
    }
    /// Generates a stamp for a given instant.
    /// - Parameters:
    ///   - instant: Instant.
    ///   - distance: Distance function.
    /// - Returns: Stamp for the given `instant`.
    func stamp<Interval>(
        _ instant: Instant,
        distance: (Instant, Instant) -> Interval
    ) -> Stamp<Instant, Interval> {
        .init(instant, elapsed: intervalSinceEpoch(for: instant, distance))
    }
}

// MARK: Self: Comparable
extension Calendar: Comparable where Instant: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.epoch < rhs.epoch
    }
}

// MARK: Self: Equatable
extension Calendar: Equatable where Instant: Equatable {}

// MARK: Self: Sendable
extension Calendar: Sendable where Instant: Sendable {}

// MARK: Self: Strideable

extension Calendar: Strideable where Instant: Strideable {
    // swiftlint:disable:next missing_docs
    public func advanced(by n: Instant.Stride) -> Self {
        .init(epoch: epoch.advanced(by: n))
    }
    // swiftlint:disable:next missing_docs
    public func distance(to other: Self) -> Instant.Stride {
        epoch.distance(to: other.epoch)
    }
}

// MARK: Self.Instant: Strideable
public extension Calendar where Instant: Strideable {
    // swiftlint:disable:next missing_docs
    typealias Interval = Instant.Stride
    /// Interval between an instant and it's epoch.
    /// - Parameter instant: Instant.
    /// - Returns: Interval between `epoch` and the current `instant`.
    func intervalSinceEpoch(for instant: Instant) -> Interval {
        epoch.distance(to: instant)
    }
    /// Range representing a given interval.
    /// - Parameter interval: Interval that composes the range.
    ///
    /// - Returns: Closed range starting at the epoch with the distance of `interval` until it's upper-bound,
    /// `nil` when the new instant is before this epoch.
    func range(after interval: Interval) -> ClosedRange<Instant>? {
        range(until: epoch.advanced(by: interval))
    }
    /// Range of activity for a given stopwatch.
    /// - Parameter instant: Upper-bound instant.
    ///
    /// - Returns: Closed range representing the stopwatch's range of activity,
    /// `nil` when the instant is before this epoch.
    func range(until instant: Instant) -> ClosedRange<Instant>? {
        if instant < epoch { return nil }

        return .init(from: epoch, to: instant)
    }
    /// Generates a stamp for a given instant.
    /// - Parameter instant: Instant.
    /// - Returns: Stamp for the given `instant`.
    @inlinable
    func stamp(_ instant: Instant) -> StampOf<Instant> {
        .init(instant, elapsed: intervalSinceEpoch(for: instant))
    }
}

// MARK: AsyncSequence (EX)
public extension AsyncSequence {
    /// Creates an async sequence that streams generated stamps for the sequence of elements.
    /// - Parameters:
    ///   - calendar: Calendar used as the reference.
    ///   - distance: Function used to gather the distance between epoch and current instant .
    /// - Returns: `AsyncMapSequence` of `Stamp` instances with the type of interval you desire.
    func stamped<Interval>(
        using calendar: Calendar<Element>,
        _ distance: @escaping @Sendable (Element, Element) -> Interval
    ) -> AsyncMapSequence<Self, Stamp<Element, Interval>> {
        nonisolated(unsafe) let calendar = calendar

        return map { calendar.stamp($0, distance: distance) }
    }
}

public extension AsyncSequence where Element: Strideable {
    /// Creates an async sequence that streams generated stamps for the sequence of elements in relation to the calendar.
    /// - Parameters:
    ///   - calendar: Calendar used as the reference.
    /// - Returns: `AsyncMapSequence` of `Stamp` instances with the type of interval you desire.
    func stamped(
        using calendar: Calendar<Element>,
    ) -> AsyncMapSequence<Self, StampOf<Element>> {
        nonisolated(unsafe) let calendar = calendar

        return map { calendar.stamp($0) }
    }
}
