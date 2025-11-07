//
//  Removable.swift
//  
//
//  Created by Martônio Júnior on 11/10/23.
//

import Foundation

public protocol Removable<Remove, Removed> {
    associatedtype Remove
    associatedtype Removed = Self

    @discardableResult
    func removing(_ value: Remove) -> Removed
}

// MARK: Operators
public extension Removable {
    static func - (lhs: Self, rhs: Remove) -> Removed {
        lhs.removing(rhs)
    }
}

// MARK: Self.Removed == Self
public extension Removable where Removed == Self {
    mutating func remove(_ value: Remove) {
        self = self.removing(value)
    }

    mutating func removing(_ data: Remove...) -> Self {
        removeMany(data)
        return self
    }

    @_disfavoredOverload
    mutating func removeMany(_ elements: some Sequence<Remove>) {
        elements.forEach { remove($0) }
    }

    @discardableResult
    mutating func removeMany(_ elements: some Sequence<Remove>) -> Int where Self: Equatable {
        elements.count {
            let appended = self.removing($0)
            if appended == self { return false }

            self = appended
            return true
        }
    }

    static func -= (lhs: inout Self, rhs: Remove) {
        lhs = lhs - rhs
    }
}

public extension Sequence {
    func removing<T: Removable>(from target: T) -> T where T.Remove == Element, T.Removed == T {
        reduce(target) { $0.removing($1) }
    }

    func removing<T: Removable>(from target: inout T) where T.Remove == Element, T.Removed == T {
        target = removing(from: target)
    }
}

// MARK: Dictionary (EX)
public extension Dictionary where Value: Removable, Value.Removed == Value {
    mutating func removeInside(_ value: Value.Remove, for key: Key) {
        self[key]?.remove(value)
    }

    mutating func removeInsideAll(_ value: Value.Remove) {
        keys.forEach {
            self[$0]?.remove(value)
        }
    }
}
