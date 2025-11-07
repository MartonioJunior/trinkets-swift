//
//  Measured.swift
//  Trinkets
//
//  Created by Martônio Júnior on 02/09/2025.
//

@propertyWrapper
public struct Measured<M: Measurable & Convertible> {
    // MARK: Variables
    var measurement: M.Measure
    let unit: M

    // MARK: Property Wrapper
    public var wrappedValue: M.Measure {
        get { measurement }
        set { measurement = newValue.converted(to: unit) }
    }

    // MARK: Initializers
    public init(wrappedValue value: M.Measure, in unit: M) {
        measurement = value.converted(to: unit)
        self.unit = unit
    }

    public init(_ value: M.Value, _ unit: M = .base) {
        measurement = .init(value: value, unit: unit)
        self.unit = unit
    }
}

// MARK: Self: Equatable
extension Measured: Equatable where M: Equatable, M.Measure: Equatable {}

// MARK: Self: Sendable
extension Measured: Sendable where M: Sendable, M.Measure: Sendable {}
