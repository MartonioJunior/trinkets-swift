//
//  Converter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

public protocol Converter {
    associatedtype Value

    func baseValue(of value: Value) -> Value
    func convert(_ baseValue: Value) -> Value?
}

// MARK: Default Implementation
public extension Converter {
    func convert(_: Value) -> Value? { nil }
}

// MARK: Dimension (EX)
public extension Dimension where Features: Converter, Features.Value == Value, Value == Double {
    static func baseValue(of value: Value, _ unit: Unit) -> Value {
        unit.features.baseValue(of: value)
    }

    static func convert(_ baseValue: Value, to unit: Unit) -> Value {
        guard let value = unit.features.convert(baseValue) else { return .nan }

        return value
    }
}
