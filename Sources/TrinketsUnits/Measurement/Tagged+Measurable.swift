//
//  Tagged+Measurable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/06/2026.
//

import Tagged

extension Tagged: Measurable where Tag: StaticUnit {
    // swiftlint:disable:next missing_docs
    public typealias Unit = Tag
    // swiftlint:disable:next missing_docs
    public typealias Quantity = RawValue
    // swiftlint:disable:next missing_docs
    public var quantity: RawValue { rawValue }
}

// MARK: Self.RawValue: FloatingPoint
public extension Tagged where Tag: StaticUnit, RawValue: FloatingPoint {
    /// Divides a measure by another.
    /// - Parameters:
    ///   - lhs: A measure.
    ///   - rhs: Another measure.
    ///
    /// - Returns: A new measure that divides the numerator value by the denominator.
    static func / (lhs: Self, rhs: Self) -> RawValue {
        lhs.rawValue / rhs.rawValue
    }
}
