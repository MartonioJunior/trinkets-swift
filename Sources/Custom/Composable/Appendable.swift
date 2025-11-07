//
//  Appendable.swift
//  
//
//  Created by Martônio Júnior on 11/10/23.
//

import Foundation

/// Protocol that defines a type that can have elements appended to it.
public protocol Appendable<Append, Appended> {
    /// Element that can be appended to the type.
    associatedtype Append
    /// Result of the append operation.
    associatedtype Appended = Self

    /// Appends a value to the object.
    func appending(_ value: Append) -> Appended
}

// MARK: Operators
public extension Appendable {
    /// Creates a new version of the object with the specified element appended to it.
    static func + (lhs: Self, rhs: Append) -> Appended {
        lhs.appending(rhs)
    }
}

// MARK: Self.Appended == Self
public extension Appendable where Appended == Self {
    mutating func append(_ value: Append) {
        self = self.appending(value)
    }
    /// Returns a new version of the object with the specified elements appended to it.
    /// - Parameter elements: The elements to append.
    mutating func appending(_ elements: Append...) -> Self {
        appendMany(elements)
        return self
    }
    /// Appends multiple elements to the object.
    @_disfavoredOverload
    mutating func appendMany(_ elements: some Sequence<Append>) {
        elements.forEach { append($0) }
    }
    /// Appends multiple elements to the object.
    /// - Returns: the number of elements successfully appended.
    @discardableResult
    mutating func appendMany(_ elements: some Sequence<Append>) -> Int where Self: Equatable {
        elements.count {
            let appended = self.appending($0)
            if appended == self { return false }

            self = appended
            return true
        }
    }
    /// Appends an element to the object in place.
    static func += (lhs: inout Self, rhs: Append) {
        lhs.append(rhs)
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Appends all elements of the sequence to the target.
    func appending<T: Appendable>(to target: T) -> T where T.Append == Element, T.Appended == T {
        reduce(target) { $0.appending($1) }
    }
    /// Appends all elements of the sequence to an appendable target.
    /// - Parameter target: The target to which elements will be appended.
    func appending<T: Appendable>(into target: inout T) where T.Append == Element, T.Appended == T {
        target = appending(to: target)
    }
}

// MARK: Dictionary (EX)
public extension Dictionary where Value: Appendable, Value.Appended == Value {
    mutating func appendInside(
        _ value: Value.Append,
        for key: Key
    ) where Value: ExpressibleByArrayLiteral {
        self[key, default: []].append(value)
    }
}
