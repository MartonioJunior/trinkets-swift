//
//  Stamp.swift
//  Trinkets
//
//  Created by Martônio Júnior on 21/07/2025.
//

/// Alias for a marker representing a `Strideable` type.
public typealias StampOf<S: Strideable> = Stamp<S, S.Stride>
/// Data structure that pairs an instant with the interval since it's last update.
/// - Instant: Representation of state for the object.
/// - Interval: Distance between states.
/// 
/// This structure is flexible enough in which it allows one to:
/// - Represent updates in an `AsyncSequence`.
/// - Mark a point of reference.
/// - Track value updates in order to avoid repeating work.
/// - Have a window of cooldown for updates.
/// - Accumulate elapsed intervals.
public struct Stamp<Instant, Interval> {
    /// Instant used as the reference for the stamp.
    /// 
    /// Tends to be the reference point used to calculate the interval to the last instant.
    /// 
    /// Set this directly to update this property without accumulating the interval up to it.
    public var reference: Instant
    /// Interval representing the distance from the starting state.
    /// 
    /// Tends to be an accumulator of intervals to inform the elapsed distance between states.
    /// 
    /// Set this directly to update this property without changing the reference instant.
    public var elapsed: Interval
    // MARK: Initializers
    /// Creates a new stamp.
    /// - Parameters:
    ///   - reference: Reference instant.
    ///   - elapsed: Distance between updates.
    public init(_ reference: Instant, elapsed: Interval) {
        self.elapsed = elapsed
        self.reference = reference
    }
}

// MARK: Self: Equatable
extension Stamp: Equatable where Instant: Equatable, Interval: Equatable {}

// MARK: Self: Sendable
extension Stamp: Sendable where Instant: Sendable, Interval: Sendable {}

// MARK: Self.Instant: Strideable
public extension Stamp where Instant: Strideable, Interval == Instant.Stride {
    /// Moves back the stamp by a given interval.
    /// - Parameter interval: Interval to go back.
    mutating func backtrack(by interval: Interval) {
        backtrack(by: interval) { $0.advanced(by: -$1) }
    }
    /// Advances the stamp by a given internal.
    /// - Parameter interval: Interval to be added.
    mutating func advance(by newDelta: Interval) {
        advance(by: newDelta) { $0.advanced(by: $1) }
    }
    /// Updates the stamp to the most recent instant.
    /// - Parameter newInstant: Instant.
    mutating func advance(to newInstant: Instant) {
        advance(to: newInstant) { $0.distance(to: $1) }
    }
}

// MARK: Self.Interval: AdditiveArithmetic
public extension Stamp where Interval: AdditiveArithmetic {
    /// Creates a new stamp.
    /// - Parameter startedAt: Reference instant of the stamp.
    init(startedAt: Instant) {
        self.init(startedAt, elapsed: .zero)
    }
    /// Advances the stamp's state by a given internal.
    /// - Parameters:
    ///   - interval: Interval to be added.
    ///   - resolve: Function calculating the instant of the latest update.
    mutating func advance(
        by interval: Interval,
        resolve: (Instant, Interval) -> Instant
    ) {
        reference = resolve(reference, interval)
        elapsed += interval
    }
    /// Updates the stamp to the most recent instant.
    /// - Parameters:
    ///   - newInstant: Instant.
    ///   - resolve: Function calculating the elapsed time since last update.
    mutating func advance(
        to newInstant: Instant,
        resolve: (Instant, Instant) -> Interval
    ) {
        elapsed += resolve(reference, newInstant)
        reference = newInstant
    }
    /// Moves back the stamp by a given interval.
    /// - Parameters:
    ///   - interval: Interval to go back.
    ///   - resolve: Function to offset the last update.
    mutating func backtrack(
        by interval: Interval,
        resolve: (Instant, Interval) -> Instant
    ) {
        reference = resolve(reference, interval)
        elapsed -= interval
    }
    /// Resets the stamp to the given instant.
    /// - Parameter instant: Instant when the stamp was reset.
    mutating func restart(at instant: Instant) {
        reference = instant
        elapsed = .zero
    }
    /// Resets the elapsed time accumulated in the stamp.
    mutating func resetIntervalOnly() {
        elapsed = .zero
    }
}

// MARK: Self.Interval: SignedNumeric
public extension Stamp where Interval: SignedNumeric & Comparable {
    /// Multiplies the stamp's interval by a given tempo.
    /// - Parameters:
    ///   - lhs: Stamp.
    ///   - rhs: Tempo.
    /// - Returns: Stamp with the same instant, but with the interval resized by the tempo.
    static func * (lhs: Self, rhs: Tempo<Interval>) -> Self {
        .init(lhs.reference, elapsed: lhs.elapsed * rhs)
    }
}

// MARK: Self.Instant: Strideable
public extension Stamp where Instant: Strideable, Instant.Stride == Interval {
    /// Range represented by this stamp.
    var range: ClosedRange<Instant> {
        if elapsed >= 0 {
            reference...reference.advanced(by: elapsed)
        } else {
            reference.advanced(by: -elapsed)...reference
        }
    }
}

// MARK: AsyncSequence (EX)
public extension AsyncSequence {
    /// Creates an async sequence that streams generated stamps for the sequence of elements.
    /// - Parameter distance: Function used to gather the distance between the current and last elements.
    /// - Returns: `AsyncMapSequence` of `Stamp` instances with the type of interval you desire.
    func stamped<Interval>(
        by distance: @escaping @Sendable (Element, Element) -> Interval
    ) -> AsyncMapSequence<Self, Stamp<Element, Interval>> {
        nonisolated(unsafe) var lastElement: Element?

        return map {
            let result = if let i = lastElement {
                distance(i, $0)
            } else {
                distance($0, $0)
            }

            lastElement = $0
            return Stamp($0, elapsed: result)
        }
    }
}

public extension AsyncSequence where Element: Strideable & SendableMetatype {
    /// Creates an async sequence that streams stamps for the sequence of elements.
    var stamped: AsyncMapSequence<Self, Stamp<Element, Element.Stride>> {
        stamped { $0.distance(to: $1) }
    }
}
