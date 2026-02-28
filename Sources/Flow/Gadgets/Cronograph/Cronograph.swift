//
//  Cronograph.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/10/2025.
//

/// Data structure used for managing instant updates.
/// 
/// Used as a building block to build actual timers, stopwatches and more
public struct Cronograph<Instant: Strideable> {
    // swiftlint:disable:next missing_docs
    public typealias Interval = Instant.Stride
    /// Pace of updates, working as a multiplier for the intervals.
    public typealias Cadence = Instant.Stride
    // MARK: Variables
    /// Starting point for the cronograph.
    var start: Calendar<Instant>
    /// Stamp used to accumulate intervals and store the last update.
    var stamp: StampOf<Instant>
    /// Tempo for updates on the stamp.
    var tempo: Tempo<Cadence>
    /// Function sourcing the current state.
    public var source: () -> Instant
    /// Current state of updates for the component.
    public private(set) var status: Status
    /// Elapsed distance between states.
    public var elapsed: Interval { stamp.elapsed }
    /// Last update for the stamp.
    public var lastUpdate: Instant { stamp.reference }
    // MARK: Initializers
    /// Creates a new cronograph.
    /// - Parameters:
    ///   - stamp: Stamp used as the base of updates
    ///   - tempo: Current tempo for this cronograph.
    ///   - status: Operational status for this chronograph.
    ///   - source: Function sourcing the current state.
    public init(
        _ stamp: StampOf<Instant>,
        tempo: Tempo<Cadence> = .forward,
        status: Status = .idle,
        source: @escaping () -> Instant
    ) {
        self.stamp = stamp
        self.tempo = tempo
        self.status = status
        self.start = .init(epoch: stamp.reference)
        self.source = source
    }
    // MARK: Methods
    /// Freezes the cronograph's updates while keeping it operational.
    public mutating func freeze() {
        tempo = .halt
    }
    /// Restarts the cronograph back in it's initial state.
    mutating func restart() {
        stamp.restart(at: start.epoch)
        tempo = .forward
        status = .running
    }
}

// MARK: Self: Metronome
extension Cronograph: Metronome {
    // swiftlint:disable:next missing_docs
    public mutating func tick(by tempo: Tempo<Cadence>) {
        let newInstant = source()

        switch status {
            case .idle:
                return
            case .running:
                let interval = stamp.reference.distance(to: newInstant)
                stamp.advance(by: interval * tempo)
            case .paused:
                stamp.reference = newInstant
        }
    }
}

// MARK: Self: Operational
extension Cronograph: Operational {
    // swiftlint:disable:next missing_docs
    public typealias Status = CronographStatus
}

// MARK: Self: Pausable
extension Cronograph: Pausable {
    // swiftlint:disable:next missing_docs
    public mutating func pause() {
        status = .paused
    }
}

// MARK: Self: Resumable
extension Cronograph: Resumable {
    // swiftlint:disable:next missing_docs
    public mutating func resume() {
        guard status == .paused else { return }

        status = .running
    }
}

// MARK: Self: Stoppable
extension Cronograph: Stoppable {
    // swiftlint:disable:next missing_docs
    public mutating func stop() {
        status = .idle
        stamp.restart(at: start.epoch)
    }
}
