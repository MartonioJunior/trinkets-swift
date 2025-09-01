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
