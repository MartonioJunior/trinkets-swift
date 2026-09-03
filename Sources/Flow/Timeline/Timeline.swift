//
//  Timeline.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2026.
//

import MatheRange
import Minimal
import SwiftVariety
/// Sampler composed of multiple heterogeneous tracks that are selected simultaneously.
/// - Chunk: Blocks that can be registered with this track.
///
/// Timelines are recommended when you want to create static value sequences that can be queried as a tuple of values.
@available(macOS 14.0.0, *)
public struct Timeline<each Chunk: Block> {
    // MARK: Variables
    /// List of tracks that are part of this timeline.
    var tracks: Tuple<repeat each Chunk>
    // MARK: Initializers
    /// Creates a new timeline.
    /// - Parameter tracks: List of tracks that compose this timeline.
    public init(_ tracks: Tuple<repeat each Chunk>) {
        self.tracks = tracks
    }
    // MARK: Methods
    /// Performs an operation with a track from the timeline
    /// - Parameter key: Key representing the track's value.
    mutating func mutateTrack<S: Selectable, R>(
        _ key: HeterogeneousKey<Int, S>,
        modify: (inout Track<S>) -> R
    ) throws(HeterogeneousKeyError) -> R {
        let key = HKey<Int, Track<S>>(key.id)
        var track = try tracks.fetch(key)
        let result = modify(&track)
        tracks.registerOrUpdate(track, for: key)
        return result
    }
    /// Performs an operation with a track from the timeline
    /// - Parameter key: Key representing the track's value.
    func withTrack<S: Selectable, R>(
        _ key: HeterogeneousKey<Int, S>,
        transform: (Track<S>) -> R
    ) throws(HeterogeneousKeyError) -> R {
        transform(try tracks.fetch(HKey<_, Track<S>>(key.id)))
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

        for track in repeat each tracks.values {
            array.append(track.mask)
        }

        return try! Mask(sequence: array)
    }
    // swiftlint:disable:next missing_docs
    public func element(on instant: Tuple<repeat (each Chunk).Mask.Bound>) -> Tuple<repeat (each Chunk).Element> {
        var array: [Any] = []

        for (track, t) in repeat (each tracks.values, each instant.values) {
            array.append(track.element(on: t))
        }

        return try! Element(sequence: array)
    }
}

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
