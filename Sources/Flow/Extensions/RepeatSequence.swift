//
//  RepeatSequence.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

/// Sequence where each element is repeated in place N times.
public struct RepeatSequence<S: Sequence> {
    // MARK: Variables
    /// Sequence of elements to be repeated.
    var sequence: S
    /// Number of times to repeat each element.
    var amount: UInt
    // MARK: Initializers
    /// Creates a new repeat sequence.
    /// - Parameters:
    ///   - sequence: Sequence of elements to be repeated.
    ///   - amount: Number of times to repeat each element
    public init(_ sequence: S, by amount: UInt) {
        self.sequence = sequence
        self.amount = amount
    }
}

// MARK: Self: Equatable
extension RepeatSequence: Equatable where S: Equatable {}

// MARK: Self: Sendable
extension RepeatSequence: Sendable where S: Sendable {}

// MARK: Self: Sequence
extension RepeatSequence: Sequence {
    // swiftlint:disable:next missing_docs
    public struct Iterator: IteratorProtocol {
        let amount: UInt
        var base: S.Iterator
        var currentCount: UInt = 0
        var currentElement: S.Element?
        // swiftlint:disable:next missing_docs
        public mutating func next() -> S.Element? {
            if amount == 0 { return nil }

            if currentCount == 0 {
                currentElement = base.next()
            }

            currentCount = (currentCount + 1) % amount
            return currentElement
        }
    }
    // swiftlint:disable:next missing_docs
    public func makeIterator() -> Iterator {
        .init(amount: amount, base: sequence.makeIterator())
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Creates a sequence that repeats the given sequence of elements by returning each element N times.
    /// - Parameter amount: Number of times to repeat the element.
    /// - Returns: Repeat sequence.
    func `repeat`(_ amount: UInt) -> RepeatSequence<Self> {
        RepeatSequence(self, by: amount)
    }
}
