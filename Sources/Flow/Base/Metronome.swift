//
//  Metronome.swift
//  Trinkets
//
//  Created by Martônio Júnior on 20/07/2025.
//

/// System that can have it's behaviour altered based on it's tempo.
/// 
/// Can be used to manipulate components based on the pacing.
/// 
/// Additionally, `tick()` can used to allow the object to self-update upon triggering.
public protocol Metronome {
    /// Raw value for the tempo.
    associatedtype Value: Numeric, Comparable
    // MARK: Methods
    /// Updates the state based on the pacing.
    mutating func tick()
    /// Updates the state based on the pacing.
    /// - Parameter tempo: Pacing used for updates.
    mutating func tick(by tempo: Tempo<Value>)
}

// MARK: Default Implementation
public extension Metronome {
    /// Updates the metronome based on a given asynchronous sequence.
    /// 
    /// This provides a concurrency-based solution for updating the metronome autonomously.
    /// - Parameter sequence: Async sequence used to provide updates to the type.
    /// - Throws: `S.Failure` when the async sequence throws.
    /// 
    /// Additionally, metronomes that can also be wrapped in a task in order to cancel it's iteration:
    /// ```swift
    /// Task { try await metronome.refresh(basedOn: asyncSequence) }
    /// ```
    mutating func refresh<S: AsyncSequence>(basedOn sequence: S) async throws {
        for try await _ in sequence {
            tick()
        }
    }
    /// Updates the metronome based on a given asynchronous sequence.
    /// 
    /// This provides a concurrency-based solution for updating the metronome autonomously.
    /// - Parameter sequence: Async sequence used to provide updates to the type.
    /// - Throws: `S.Failure` when the async sequence throws.
    /// 
    /// Additionally, metronomes that can also be wrapped in a task in order to cancel it's iteration:
    /// ```swift
    /// Task {
    ///   try await metronome.refresh(basedOn: asyncSequence) { element in 
    ///     // Define pacing based on the element...
    ///   }
    /// }
    /// ```
    mutating func refresh<S: AsyncSequence>(basedOn sequence: S, _ pacing: (S.Element) -> Tempo<Value>) async throws {
        for try await i in sequence {
            tick(by: pacing(i))
        }
    }
    // swiftlint:disable:next missing_docs
    mutating func tick() { tick(by: .forward) }
}

// MARK: MutableCollection (EX)
public extension MutableCollection where Element: Metronome {
    /// Updates the state based on the pacing.
    mutating func tick() {
        indices.forEach { self[$0].tick() }
    }
    /// Updates the state based on the pacing.
    /// - Parameter tempo: Pacing used for updates.
    mutating func tick(by tempo: Tempo<Element.Value>) {
        indices.forEach { self[$0].tick(by: tempo) }
    }
}
