//
//  Playback.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/07/2026.
//

/// Data structure describing the behaviour of execution for multiple iterations.
public struct Playback {
    // MARK: Variables
    /// Number of iterations to be executed.
    var loop: Loop
    /// How should the component handle going from one iteration to another.
    /// 
    /// `nil` indicates that wrapping should not happen.
    var wrap: Wrap?
    // MARK: Initializers
    /// Creates a new skip model.
    /// - Parameters:
    ///   - loop: Number of iterations to be executed.
    ///   - wrap: How to skip to the next iteration?
    public init(_ loop: Loop, wrap: Wrap? = nil) {
        self.loop = loop
        self.wrap = wrap
    }
    // MARK: Methods
    /// Advances playback to the next cycle.
    /// - Returns: `true` when it moves to the next loop, `false` when there's no loops remaining.
    public mutating func advance() -> Bool {
        switch loop {
            case .endless:
                return true
            case let .fixed(n) where n > 0:
                loop = .fixed(n - 1)
                return true
            default:
                return false
        }
    }
}

// MARK: Self.Loop
public extension Playback {
    /// Enum defining the number of loops.
    enum Loop {
        /// Execution loops for a number of iterations.
        case fixed(UInt)
        /// Execution goes on indefinitely until halted.
        case endless
    }
}

public extension Playback.Loop {
    /// Executes the wrap only once.
    static var oneShot: Self { .fixed(0) }
}

extension Playback.Loop: Codable {}
extension Playback.Loop: Equatable {}
extension Playback.Loop: Sendable {}

// MARK: Self.Wrap
public extension Playback {
    /// Enum defining the wrap behaviour at the activation instant.
    enum Wrap {
        /// Execution is halted at the activation instant.
        case freeze
        /// Execution is paused at the activation instant.
        case hold
        /// Execution is reset back to the start.
        case reset
    }
}

extension Playback.Wrap: Codable {}
extension Playback.Wrap: Equatable {}
extension Playback.Wrap: Sendable {}

// MARK: Self: Codable
extension Playback: Codable {}

// MARK: Self: Equatable
extension Playback: Equatable {}

// MARK: Self: Sendable
extension Playback: Sendable {}
