//
//  Counter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 03/01/2026.
//

/// Component that advances state in fixed increments.
public struct Counter {
    // MARK: Variables
    /// Current value for the counter.
    public private(set) var count: Int
    /// Tempo of the counter.
    var jump: Tempo<Int>
    // MARK: Initializers
    /// Creates a new counter.
    /// - Parameters:
    ///   - count: Initial value for the counter.
    ///   - jump: Tempo of the counter.
    public init(_ count: Int = 0, jump: Tempo<Int> = .forward) {
        self.count = count
        self.jump = jump
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Counter: ExpressibleByIntegerLiteral {
    // swiftlint:disable:next missing_docs
    public init(integerLiteral value: Int) {
        self.init(value, jump: .forward)
    }
}

// MARK: Self: Metronome
extension Counter: Metronome {
    // swiftlint:disable:next missing_docs
    public mutating func tick(by tempo: Tempo<Int>) {
        count += (jump * tempo).multiplier
    }
}

// MARK: Self: Sendable
extension Counter: Sendable {}

// MARK: Self: Strideable
extension Counter: Strideable {
    // swiftlint:disable:next missing_docs
    public func advanced(by n: Int) -> Self {
        .init(count + n, jump: jump)
    }
    // swiftlint:disable:next missing_docs
    public func distance(to other: Self) -> Int {
        other.count - count
    }
}
