//
//  Appendable.swift
//  
//
//  Created by Martônio Júnior on 11/10/23.
//

import Foundation

/// Type that can have elements appended to it.
/// 
/// Describes the assimilation of elements, increase of value and advancements into a model.
/// 
/// Can be used to create structures such as:
/// - In-game equipment
/// - Upgrades
/// - Advancing to the next level and/or battle
public protocol Appendable<Append, Appended> {
    /// Element that can be appended to the type.
    associatedtype Append
    /// Result of the append operation.
    associatedtype Appended = Self
    // MARK: Methods
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

// MARK: Self.Append == Void
public extension Appendable where Self.Append == Void {
    /// Alias representing an upgrade for the current state.
    typealias Upgrade = Append
    /// Alias representing the upgraded state.
    /// - In Optional definitions, `nil` indicates that it can't be further upgraded.
    /// - In `Never` definitions, blocks any upgrades from happening, even if it conforms.
    typealias Upgraded = Appended
    /// Upgraded version of this value.
    var upgraded: Upgraded { appending(()) }
}

public extension Appendable where Self.Append == Void, Appended == Self {
    /// Upgrades this value.
    mutating func upgrade() { append(()) }
    /// Upgrades this value a set amount of times.
    /// - Parameter step: Number of times to upgrade.
    mutating func upgrade(by step: UInt) {
        for _ in 0..<step { upgrade() }
    }
}

// MARK: Self.Appended == Self
public extension Appendable where Appended == Self {
    /// Appends a value to this object.
    /// - Parameter value: Value to be appended.
    mutating func append(_ value: Append) {
        self = self.appending(value)
    }
    /// New version of the object with the specified elements appended to it.
    /// - Parameter elements: Elements to append.
    /// - Returns: Modified object.
    mutating func appending(_ elements: Append...) -> Self {
        appendMany(elements)
        return self
    }
    /// Appends multiple elements to the object.
    /// - Parameter elements: Elements to be appended.
    @_disfavoredOverload
    mutating func appendMany(_ elements: some Sequence<Append>) {
        elements.forEach { append($0) }
    }
    /// Appends multiple elements to the object.
    /// - Parameter elements: Elements to be appended.
    /// - Returns: Number of elements successfully appended.
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
    /// - Parameters:
    ///   - lhs: Target to be mutated.
    ///   - rhs: Value to be appended.
    static func += (lhs: inout Self, rhs: Append) {
        lhs.append(rhs)
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Creates a target by appending elements of the sequence to the target.
    /// - Parameter target: Instance to add elements to.
    /// - Returns: Target with the appended elements.
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
    /// Appends an element to a Dictionary's value at the given key.
    /// - Parameters:
    ///   - element: Element to be appended.
    ///   - key: Location of the value to be appended to.
    ///
    mutating func appendInside(
        _ element: Value.Append,
        for key: Key
    ) where Value: ExpressibleByArrayLiteral {
        self[key, default: []].append(element)
    }
}
