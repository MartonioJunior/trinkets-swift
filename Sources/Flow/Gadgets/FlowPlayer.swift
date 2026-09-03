//
//  FlowPlayer.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2025.
//

/// Component that translates the activity of a cronograph into state through sampling.
/// - Instant: Infinitesimal interval whose passage is instantaneous.
/// - Value: Result of the player's analysis against a sampler.
public struct FlowPlayer<Instant: Strideable, Value> {
    /// Progress from the initial state to the current one.
    public typealias Interval = Instant.Stride
    // MARK: Variables
    /// Sampler of state for the player.
    var sampler: @Sendable (Instant) -> Value
    /// Cronograph that powers this component.
    var cronograph: Cronograph<Instant>
    // swiftlint:disable:next missing_docs
    public var playback: Playback
    /// Elapsed time on the player.
    public var elapsed: Interval { cronograph.elapsed }
    /// Tempo used by the player.
    public var tempo: Tempo<Instant.Stride> {
        get { cronograph.tempo }
        set { cronograph.tempo = newValue }
    }
    // MARK: Initializers
    /// Creates a new player.
    /// - Parameters:
    ///   - cronograph: Cronograph used to power this component.
    ///   - playback: Behaviour of execution for this type.
    ///   - sampler: Sampler of state for the player.
    ///
    public init(
        _ cronograph: Cronograph<Instant>,
        settings playback: Playback = .init(.oneShot, wrap: .none),
        _ sampler: @escaping @Sendable (Instant) -> Value,
    ) {
        self.sampler = sampler
        self.cronograph = cronograph
        self.playback = playback
    }
    // MARK: Methods
    /// Obtains sampled state based on the cronograph's state, skipping into the next iteration.
    /// - Parameters:
    ///   - input: State of the cronograph to be used.
    ///   - transform: Function to match to the results.
    /// 
    /// When successful, skips to the next iteration of the loop or stays halted.
    mutating func consume<T>(
        _ input: (Cronograph<Instant>) -> Instant,
        transform: (Value?) -> T
    ) -> T {
        guard status == .running else { return transform(nil) }

        let result = transform(sample(by: input))
        skip()
        return result
    }
    /// Consumes state by the given instant, skipping into the next iteration.
    /// - Parameter f: Function to match to the results.
    /// 
    /// When successful, skips to the next iteration of the loop or stays halted.
    public mutating func consumeInstant<T>(_ f: (Value?) -> T) -> T {
        consume(\.lastUpdate, transform: f)
    }
    /// Obtains the sample for the current sampler based on the cronograph.
    /// - Parameter input: State of the cronograph to be used.
    /// - Returns: Sampled value.
    public func sample(by input: (Cronograph<Instant>) -> Instant) -> Value {
        sampler(input(cronograph))
    }
}

// MARK: Self: Equatable
extension FlowPlayer: Equatable {
    // swiftlint:disable:next missing_docs
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.cronograph == rhs.cronograph &&
        lhs.playback == rhs.playback
    }
}

// MARK: Self: Metronome
extension FlowPlayer: Metronome {
    // swiftlint:disable:next missing_docs
    public mutating func tick() {
        cronograph.tick()
    }
    // swiftlint:disable:next missing_docs
    public mutating func tick(by tempo: Tempo<Interval>) {
        cronograph.tick(by: tempo)
    }
}

// MARK: Self: Operational
extension FlowPlayer: Operational {
    // swiftlint:disable:next missing_docs
    public var status: CronographStatus { cronograph.status }
}

// MARK: Self: Pausable
extension FlowPlayer: Pausable {
    // swiftlint:disable:next missing_docs
    public mutating func pause() {
        cronograph.pause()
    }
}

// MARK: Self: Resumable
extension FlowPlayer: Resumable {
    // swiftlint:disable:next missing_docs
    public mutating func resume() {
        cronograph.resume()
    }
}

// MARK: Self: Sendable
extension FlowPlayer: Sendable where Instant: Sendable, Instant.Stride: Sendable, Value: Sendable {}

// MARK: Self: Skippable
extension FlowPlayer: Skippable {
    // swiftlint:disable:next missing_docs
    public mutating func skip() {
        if playback.advance() {
            cronograph.restart()
            return
        }

        switch playback.wrap {
            case .freeze:
                cronograph.freeze()
            case .hold:
                cronograph.pause()
            case .reset:
                cronograph.stop()
            case .none:
                return
        }
    }
}

// MARK: Self: Stoppable
extension FlowPlayer: Stoppable {
    // swiftlint:disable:next missing_docs
    public mutating func stop() {
        cronograph.stop()
    }
}

// MARK: Self.Instant == Self.Interval
public extension FlowPlayer where Instant == Interval {
    /// Consumes state by the given elapsed interval, skipping into the next iteration.
    /// - Parameter f: Function to match to the results.
    /// 
    /// When successful, skips to the next iteration of the loop or stays halted.
    mutating func consumeInterval<T>(_ f: (Value?) -> T) -> T {
        consume(\.elapsed, transform: f)
    }
}
