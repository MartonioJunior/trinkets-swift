//
//  Meter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/07/2025.
//

import MatheRange
/// Meter for a A...B range.
public typealias ClosedMeter<Value: Comparable> = Meter<ClosedRange<Value>>
/// Meter for a A..<B range.
public typealias OpenMeter<Value: Comparable> = Meter<Range<Value>>
/// Meter for a A... range.
public typealias PartialMeterFrom<Value: Comparable> = Meter<PartialRangeFrom<Value>>
/// Meter for a ...B range.
public typealias PartialMeterThrough<Value: Comparable> = Meter<PartialRangeThrough<Value>>
/// Meter for a ..<B range.
public typealias PartialMeterUpTo<Value: Comparable> = Meter<PartialRangeUpTo<Value>>
/// Data structure for managing an instant inside of a given boundary of values.
/// 
/// Example:
/// ```swift
/// @Meter(0...maxMp) var mp: Int
/// ```
@propertyWrapper
public struct Meter<B: Boundary> {
    /// Type representing an instant inside of the meter.
    public typealias Instant = B.Bound
    // MARK: Variables
    /// Boundary of valid values for the meter.
    public internal(set) var boundary: B
    /// Current state of the meter.
    public internal(set) var instant: Instant
    /// Projection for the meter itself.
    public var projectedValue: Self {
        get { self }
        set { self = newValue }
    }
    /// Current instant of the meter.
    public var wrappedValue: Instant { instant }
    // MARK: Initializer
    /// Creates a new meter.
    /// - Parameters:
    ///   - defaultValue: Starting value of the meter. Can be outside of the meter's boundary.
    ///   - boundary: Boundary representing all valid values representable by the meter.
    ///
    public init(wrappedValue defaultValue: Instant, _ boundary: B) {
        self.instant = defaultValue
        self.boundary = boundary
    }
    // MARK: Methods
    /// Maps a meter into a new value.
    /// - Parameter transform: Mapping function using the boundary and instant.
    /// - Returns: New value `T` obtained by transforming over the meter.
    public func map<T>(_ transform: (B, Instant) -> T) -> T {
        transform(boundary, instant)
    }
    /// Maps the meter to a new boundary.
    /// - Parameter transform: Mapping function for the boundary.
    /// - Returns: New `Meter` with the transformed boundary at the same instant.
    public func mapBoundary<Other: Boundary>(_ transform: (B) -> Other) -> Meter<Other> where Other.Bound == B.Bound {
        .init(wrappedValue: instant, transform(boundary))
    }
    /// Maps the instant to a new value independent of boundary constraints.
    /// - Parameter transform: Mapping function for the instant.
    /// - Returns: New `Meter` with the transformed instant using the same boundary.
    public func mapValue(_ transform: (Instant) -> Instant) -> Self {
        .init(wrappedValue: transform(instant), boundary)
    }
    /// Attempts to update the current instant in the meter.
    /// - Parameters:
    ///   - newValue: Instant to set the meter to.
    ///   - ignoreBoundary: Should the value be set even when outside of the boundary?
    /// 
    /// Note: if `ignoreBoundary` is set to false, passing in a value that's outside of it
    /// does not mutate the meter.
    public mutating func setInstant(_ newValue: Instant, ignoreBoundary: Bool = false) {
        guard ignoreBoundary || boundary.contains(newValue) else { return }

        instant = newValue
    }
    /// Updates the meter's current state independent of boundary constraints.
    /// 
    /// Use this method instead of `setInstant(_:ignoreBoundary)` when you don't need
    /// to validate that the value is inside of the boundary.
    /// - Parameter newValue: Instant to set the meter to.
    public mutating func override(to newValue: Instant) {
        instant = newValue
    }
}

// MARK: DotSyntax
public extension Meter {
    /// Creates a new meter ranging from zero up to and including `upperBound`.
    /// - Parameters:
    ///   - upperBound: Upper bound for the meter.
    ///   - instant: Starting state for the meter.
    static func zeroThrough(
        _ upperBound: Instant,
        startAt instant: Instant = .zero
    ) -> ClosedMeter<Instant> where Instant: AdditiveArithmetic {
        .init(wrappedValue: instant, (.zero)...upperBound)
    }
    /// Creates a new meter ranging from zero up until, but not including, `upperBound`.
    /// - Parameters:
    ///   - upperBound: Upper bound for the meter.
    ///   - instant: Starting state for the meter.
    static func zeroTo(
        _ upperBound: Instant,
        startAt instant: Instant = .zero
    ) -> OpenMeter<Instant> where Instant: AdditiveArithmetic {
        .init(wrappedValue: instant, (.zero)..<upperBound)
    }
}

// MARK: Self: Equatable
extension Meter: Equatable where B: Equatable, Instant: Equatable {}

// MARK: Self: Sendable
extension Meter: Sendable where B: Sendable, Instant: Sendable {}

// MARK: Self.Value: Comparable
public extension Meter where Instant: Comparable {
    /// Creates a meter that starts from a given value.
    /// - Parameter value: Lower bound of the meter.
    static func from(_ value: Instant) -> PartialMeterFrom<Instant> {
        .init(wrappedValue: value, value...)
    }
    /// Creates a meter that goes up to a given value, including said value.
    /// - Parameter value: Upper bound of the meter.
    static func through(_ value: Instant) -> PartialMeterThrough<Instant> {
        .init(wrappedValue: value, ...value)
    }
    /// Creates a meter that goes up to, but not including a given value.
    /// - Parameter value: Upper bound of the meter.
    static func upTo(_ value: Instant) -> PartialMeterUpTo<Instant> {
        .init(wrappedValue: value, ..<value)
    }
}
