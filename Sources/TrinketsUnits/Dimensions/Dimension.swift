//
//  Dimension.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Foundation

public protocol Dimension: Domain {
    associatedtype Value: Comparable = Double

    typealias Measure = Measurement<Unit>

    static var baseUnit: Unit { get }
    static var dimensionality: Dimensionality { get }

    static func baseValue(of value: Value, _ unit: Unit) -> Value
    static func convert(_ baseValue: Value, to unit: Unit) -> Value
}

// MARK: Default Implementation
public extension Dimension {
    static var dimensionality: Dimensionality { [Self.self: 1] }

    static func `in`(_ unit: Unit) -> Unit { unit }

    static func measure<T>(
        _: T.Type = T.self,
        in unit: Unit = .base,
        _ value: @escaping (T) -> Value
    ) -> (T) -> Measure {
        { .init(value($0), unit) }
    }

    static func of(_ value: Unit.Value, _ unit: Unit) -> Measurement<Unit> {
        .init(value, unit)
    }
}
