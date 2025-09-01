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
