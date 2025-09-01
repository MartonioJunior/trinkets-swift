//
//  Measurable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 31/08/2025.
//

public protocol Measurable {
    associatedtype Value
}

// MARK: Unit (EX)
public extension Unit where D: Dimension & Measurable {
    @inlinable
    func x(_ value: D.Value) -> D.Measure {
        .init(value: value, unit: self)
    }

    @inlinable
    static func * (lhs: Self, rhs: D.Value) -> D.Measure {
        lhs.x(rhs)
    }

    @inlinable
    static func * (lhs: D.Value, rhs: Self) -> D.Measure {
        rhs.x(lhs)
    }
}
