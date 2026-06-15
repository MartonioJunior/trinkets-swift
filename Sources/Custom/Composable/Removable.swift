//
//  Removable.swift
//  
//
//  Created by Martônio Júnior on 11/10/23.
//

import Foundation

/// Type that can have elements appended to it.
/// 
/// Describes the extraction of features and addition of limitations and/or constraints.
/// 
/// Can be used to create structures such as:
/// - Unequip items
/// - Downgrades
/// - Locking levels and/or battles
public protocol Removable<Remove, Removed> {
    /// Type representing the removed element and/or criteria.
    associatedtype Remove
    /// Type representing the remainder of the original type.
    associatedtype Removed = Self
    /// Extracts a value from the object.
    /// - Parameter value: Value to be removed.
    /// - Returns: Object with `value` removed.
    @discardableResult
    func removing(_ value: Remove) -> Removed
}

// MARK: Operators
public extension Removable {
    /// Creates a new version of the object with the specified element removed from it.
    static func - (lhs: Self, rhs: Remove) -> Removed {
        lhs.removing(rhs)
    }
}

// MARK: Self.Remove == Void
public extension Removable where Self.Remove == Void {
    /// Alias representing an downgrade from the current state.
    typealias Downgrade = Remove
    /// Alias representing a downgraded state.
    /// - In Optional definitions, `nil` indicates that it can't be downgraded further.
    /// - In `Never` definitions, blocks any downgrades from happening, even if it conforms.
    typealias Downgraded = Removed
    /// Downgraded version of this value.
    var downgraded: Removed { removing(()) }
}

public extension Removable where Self.Remove == Void, Removed == Self {
    /// Downgrades this value.
    mutating func downgrade() { remove(()) }
    /// Downgrades this value a set amount of times.
    /// - Parameter step: Number of times to downgrade.
    mutating func downgrade(by step: UInt) {
        for _ in 0..<step { downgrade() }
    }
}

// MARK: Self.Removed == Self
public extension Removable where Removed == Self {
    /// Extracts a value from this object.
    /// - Parameter value: Value to be removed.
    mutating func remove(_ value: Remove) {
        self = self.removing(value)
    }
    /// New version of the object with the specified elements removed from it.
    /// - Parameter elements: Elements to extract.
    /// - Returns: Modified object.
    mutating func removing(_ elements: Remove...) -> Self {
        removeMany(elements)
        return self
    }
    /// Removes multiple elements from the object.
    /// - Parameter elements: Elements to extract.
    @_disfavoredOverload
    mutating func removeMany(_ elements: some Sequence<Remove>) {
        elements.forEach { remove($0) }
    }
    /// Removes multiple elements from the object.
    /// - Parameter elements: Elements to extract.
    /// - Returns: Number of elements successfully removed.
    @discardableResult
    mutating func removeMany(_ elements: some Sequence<Remove>) -> Int where Self: Equatable {
        elements.count {
            let appended = self.removing($0)
            if appended == self { return false }

            self = appended
            return true
        }
    }
    /// Extracts a value from the object.
    /// - Parameters:
    ///   - lhs: Target to be mutated.
    ///   - rhs: Value to be removed.
    static func -= (lhs: inout Self, rhs: Remove) {
        lhs = lhs - rhs
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Creates a target by extracting elements in this sequence from the target.
    /// - Parameter target: Instances to remove.
    /// - Returns: Target with the removed elements.
    func removing<T: Removable>(from target: T) -> T where T.Remove == Element, T.Removed == T {
        reduce(target) { $0.removing($1) }
    }
    /// Removes elements in this sequence from the target.
    /// - Parameter target: Instances to remove.
    func removing<T: Removable>(from target: inout T) where T.Remove == Element, T.Removed == T {
        target = removing(from: target)
    }
}

// MARK: Dictionary (EX)
public extension Dictionary where Value: Removable, Value.Removed == Value {
    /// Removes an element from the Dictionary's value at the given key.
    /// - Parameters:
    ///   - element: Element to be removed.
    ///   - key: Location of the value to be extracted from.
    ///
    mutating func removeInside(_ element: Value.Remove, for key: Key) {
        self[key]?.remove(element)
    }
    /// Removes an element from all Dictionary values.
    /// - Parameter element: Element to be removed.
    mutating func removeInsideAll(_ element: Value.Remove) {
        keys.forEach {
            self[$0]?.remove(element)
        }
    }
}
