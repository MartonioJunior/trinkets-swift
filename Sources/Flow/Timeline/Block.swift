//
//  Block.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

import MatheRange
/// Data structure that represents a value-mapped boundary.
/// - Instant: Type representing the bound.
/// - Value: Information associated with this boundary.
public struct Block<Instant: Strideable, Value> {
    // MARK: Variables
    /// Stamp describing the block's boundary.
    var stamp: StampOf<Instant>
    /// Function that indicates the value for a given instant or interval in the spread of values.
    var f: (Instant) -> Value
    /// Boundary that is represented by this block.
    public var boundary: ClosedRange<Instant> {
        if stamp.elapsed >= 0 {
            stamp.reference...stamp.reference.advanced(by: stamp.elapsed)
        } else {
            stamp.reference.advanced(by: -stamp.elapsed)...stamp.reference
        }
    }
    // MARK: Initializers
    /// Creates a new block.
    /// - Parameters:
    ///   - stamp: Stamp describing the block's boundary.
    ///   - f: Function that indicates the value for a given instant.
    public init(_ stamp: StampOf<Instant>, f: @escaping (Instant) -> Value) {
        self.f = f
        self.stamp = stamp
    }
}

// MARK: DotSyntax
public extension Block {
    /// Creates a new interval block with a fixed value.
    /// - Parameters:
    ///   - stamp: Stamp describing the block's boundary.
    ///   - value: Function describing the value for the entire spread.
    static func fixed(_ stamp: StampOf<Instant>, value: @autoclosure @escaping () -> Value) -> Self {
        .init(stamp) { _ in value() }
    }
    /// Creates a new instant block with a fixed value.
    /// 
    /// An instant block starts and ends at the same specified value.
    /// - Parameters:
    ///   - instant: Reference Instant.
    ///   - f: Function describing the value for the entire spread.
    static func instant(_ instant: Instant, f: @escaping (Instant) -> Value) -> Self {
        .init(.init(startedAt: instant), f: f)
    }
    /// Creates a new instant with a fixed value.
    /// 
    /// A instant block starts and ends at the same specified value.
    /// - Parameters:
    ///   - instant: Reference Instant.
    ///   - value: Function describing the value for the entire spread.
    static func instantFixed(
        _ instant: Instant,
        value: @autoclosure @escaping () -> Value
    ) -> Self {
        .instant(instant) { _ in value() }
    }
}

// MARK: Self: Selectable
extension Block: Selectable {
    // swiftlint:disable:next missing_docs
    public func canBeSelected(by selection: ClosedRange<Instant>) -> Bool {
        boundary.overlaps(selection)
    }
}

// TODO: Add Tempo support and more controls to move blocks around.
