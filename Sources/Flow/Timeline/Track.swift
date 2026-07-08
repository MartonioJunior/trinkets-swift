//
//  Track.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

import MatheRange
/// Short-hand alias for a track composed of blocks.
public typealias TrackOf<Instant: Strideable, Value> = Track<Block<Instant, Value>>
/// Data structures that composes together multiple selectable entities.
/// - Chunk: Selectable objects that can be registered with this track.
/// 
/// Tracks are recommended for defining a dynamic sequence of values of a type that is modifiable.
public struct Track<Chunk: Selectable> {
    /// Infinitesimal interval whose passage is instantaneous.
    public typealias Instant = Chunk.Selection.Bound
    // MARK: Variables
    /// List of chunks registered in this track.
    /// 
    /// When sampling chunks, they are evaluated in order, returning the first non-nil value found.
    /// Therefore, it's important to insert elements using the correspondent methods based in your intention:
    /// - `fill(_:)` adds the chunk to the end of the order, filling empty gaps with no value set.
    /// - `overwrite(_:)` adds the chunk to the start of the order, appearing above any chunks.
    var chunks: [Chunk]
    /// List of selections registered in this track, which work as jump-off points to compose a track or obtain info about it's state.
    /// 
    /// The goal with this is to provide contextual information about the contents of a track through it's selection.
    var markers: [String: Chunk.Selection]
    /// Creates a sub-track based on the given marker.
    /// - Parameter key: Key representing the selection.
    /// - Returns: Sub-track with the chunks of the marked selection.
    subscript(key: String) -> Self? {
        guard let selection = markers[key] else { return nil }

        return .init(chunks: chunks(in: selection))
    }
    // MARK: Initializers
    /// Creates a new track.
    /// - Parameters:
    ///   - chunks: List of blocks registered in this track.
    ///   - markers: List of markers registered in this track.
    public init(chunks: [Chunk], markers: [String: Chunk.Selection] = [:]) {
        self.chunks = chunks
        self.markers = markers
    }
    // MARK: Methods
    /// Removes the marker from the track.
    /// - Parameter marker: Marker to be removed.
    public mutating func clearMarker(_ marker: String) {
        markers.removeValue(forKey: marker)
    }
    /// Returns all chunks that are selectable with a given selection.
    /// - Parameter selection: Selection.
    /// - Returns: Chunks selectable by this selection.
    public func chunks(in selection: Selection) -> [Chunk] {
        chunks.filter { $0.canBeSelected(by: selection) }
    }
    /// Adds a chunk below other chunks.
    /// - Parameter chunk: Sampler to be added.
    public mutating func fill(with chunk: Chunk) {
        chunks.append(chunk)
    }
    /// Marks a selection in the track.
    /// - Parameters:
    ///   - selection: Selection defined on the track.
    ///   - marker: Key used to represent the marker.
    ///
    public mutating func mark( _ selection: Chunk.Selection, as marker: String) {
        markers[marker] = selection
    }
    /// Adds a chunk on top of the list, executing before any other elements.
    /// - Parameter chunk: Block to be added.
    public mutating func overwrite(with chunk: Chunk) {
        chunks.insert(chunk, at: 0)
    }
    /// Obtains a reference selection from a given marker registered in the track.
    /// - Parameter marker: Marker used for registration.
    /// - Returns: Range associated with the marker, `nil` when `marker` is not registered.
    public func selection(forKey marker: String) -> Chunk.Selection? {
        markers[marker]
    }
}

// MARK: Self: Selectable
extension Track: Selectable {
    // swiftlint:disable:next missing_docs
    public func canBeSelected(by selection: Chunk.Selection) -> Bool {
        chunks.canBeSelected(by: selection)
    }
}
