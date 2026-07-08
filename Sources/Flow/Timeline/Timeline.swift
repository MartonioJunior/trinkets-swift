//
//  Timeline.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/07/2026.
//

import MatheRange
import SwiftVariety
/// Sampler composed of multiple heterogeneous tracks that are selected simultaneously.
/// - Chunk: Selectable selectors object that can be registered with this track.
///
/// Timelines are recommended when you want to create static value sequences that can be queried as a tuple of values.
@available(macOS 14.0.0, *)
public struct Timeline<each Chunk: Selectable> {
    // MARK: Variables
    /// List of tracks that are part of this timeline.
    var tracks: Tuple<repeat Track<each Chunk>>
    // MARK: Initializers
    /// Creates a new timeline.
    /// - Parameter tracks: List of tracks that compose this timeline.
    public init(_ tracks: Tuple<repeat Track<each Chunk>>) {
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

// MARK: Self.Snapshot
@available(macOS 14.0.0, *)
public extension Timeline {
    /// Evaluation of the timeline's state at a given instant.
    typealias Snapshot = Tuple<repeat [each Chunk]>
    /// Creates a snapshot of the timeline based on the 
    /// - Parameter selection: Selection.
    /// - Returns: Snapshot of the chunks on each track selectable by this selection.
    func chunks<Selection: Boundary>(in selection: Selection) -> Snapshot {
        var array: [Any] = []
        var index: Int = 0

        for type in repeat (each Chunk).self {
            guard type.Selection == Selection.self else { continue }

            _ = try? withTrack(HKey(index, type)) {
                array.append($0.chunks(in: unsafeBitCast(selection, to: type.Selection)))
            }
            index += 1
        }

        return try! Snapshot(sequence: array)
    }
}
