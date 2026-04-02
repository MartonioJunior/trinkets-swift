//
//  Convertible.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/09/2025.
//

public protocol Convertible: Measurable {
    static var base: Self { get }

    static func baseValue(of value: Value, _ unit: Self) -> Value
    static func convert(_ baseValue: Value, to unit: Self) -> Value
}

// MARK: Default Implementation
public extension Convertible {
    static func measure<T>(
        _ type: T.Type = T.self,
        _ value: @escaping (T) -> Value
    ) -> (T) -> Measure {
        measure(type, in: .base, value)
    }
}
