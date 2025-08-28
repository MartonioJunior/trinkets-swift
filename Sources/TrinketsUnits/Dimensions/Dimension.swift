//
//  Dimension.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Foundation

public protocol Dimension: Domain {
    associatedtype Value: Comparable = Double

    typealias Measure = Measurement<Self, Value>

    static var baseUnit: Unit { get }
    static var dimensionality: Dimensionality { get }

    static func baseValue(of value: Value, _ unit: Unit) -> Value
    static func convert(_ baseValue: Value, to unit: Unit) -> Value
}

// MARK: Default Implementation
public extension Dimension {
    static var dimensionality: Dimensionality { [Self.self: 1] }

    static func of(_ value: Value, _ unit: Unit) -> Measurement<Self, Value> {
        .init(value: value, unit: unit)
    }

    static func `in`(_ unit: Unit) -> Unit { unit }
}

// MARK: Unit (EX)
public extension Unit where D: Dimension {
    static var `default`: Self { D.baseUnit }
}
