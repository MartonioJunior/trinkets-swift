//
//  Timeline.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2026.
//

import MatheRange
import Minimal
/// Sampler composed of multiple heterogeneous blocks that are selected simultaneously.
/// - Chunk: Blocks that can be registered with this timeline.
///
/// Timelines are recommended when you want to create static value sequences that can be queried as a tuple of values.
@available(macOS 14.0.0, *)
public struct Timeline<each Chunk: Block> {
    // MARK: Variables
    /// List of blocks that are part of this timeline.
    var blocks: Tuple<repeat each Chunk>
    // MARK: Initializers
    /// Creates a new timeline.
    /// - Parameter blocks: List of blocks that compose this timeline.
    public init(_ blocks: Tuple<repeat each Chunk>) {
        self.blocks = blocks
    }
    // MARK: Methods
    /// Performs an operation with a block from the timeline
    /// - Parameter keyPath: Key Path representing the block.
    mutating func mutateBlock<B: Block, R>(
        _ keyPath: WritableKeyPath<(repeat each Chunk), B>,
        modify: (inout B) -> R
    ) -> R {
        var block = blocks.values[keyPath: keyPath]
        let result = modify(&block)
        blocks.values[keyPath: keyPath] = block
        return result
    }
    /// Performs an operation with a block from the timeline
    /// - Parameter keyPath: Key Path representing the block.
    func withBlock<B: Block, R>(
        _ keyPath: KeyPath<(repeat each Chunk), B>,
        transform: (B) -> R
    ) -> R {
        transform(blocks.values[keyPath: keyPath])
    }
}

// MARK: Self: Block
@available(macOS 14.0.0, *)
extension Timeline: Block where (repeat (each Chunk).Instant) == (repeat (each Chunk).Mask.Bound) {
    // swiftlint:disable:next missing_docs
    public typealias Mask = Tuple<repeat (each Chunk).Mask>
    // swiftlint:disable:next missing_docs
    public typealias Element = Tuple<repeat (each Chunk).Element>
    // swiftlint:disable:next missing_docs
    public var mask: Tuple<repeat (each Chunk).Mask> {
        var array: [Any] = []

        for block in repeat each blocks.values {
            array.append(block.mask)
        }

        return try! Mask(sequence: array)
    }
    // swiftlint:disable:next missing_docs
    public func element(on instant: Tuple<repeat (each Chunk).Mask.Bound>) -> Tuple<repeat (each Chunk).Element> {
        var array: [Any] = []

        for (block, t) in repeat (each blocks.values, each instant.values) {
            array.append(block.element(on: t))
        }

        return try! Element(sequence: array)
    }
}

// MARK: Self: Equatable
@available(macOS 14, *)
extension Timeline: Equatable where repeat each Chunk: Equatable {}

// MARK: Self: Sendable
@available(macOS 14, *)
extension Timeline: Sendable where repeat each Chunk: Sendable {}

// MARK: Tuple (EX)
@available(macOS 14, *)
extension Tuple: @retroactive Boundary where repeat each Element: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = Tuple<repeat (each Element).Bound>
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        for (l, r) in repeat (each lhs.values, each rhs.values) {
            if l.contains(r) { return true }
        }

        return false
    }
}
