//
//  Measurable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 31/08/2025.
//

public protocol Measurable {
    associatedtype Value

    typealias Measure = Measurement<Self>
}

// MARK: Default Implementation
public extension Measurable {
    @inlinable
    func x(_ value: Value) -> Measure {
        .init(value: value, unit: self)
    }

    @inlinable
    static func * (lhs: Self, rhs: Value) -> Measure {
        lhs.x(rhs)
    }

    @inlinable
    static func * (lhs: Value, rhs: Self) -> Measure {
        rhs.x(lhs)
    }
}
