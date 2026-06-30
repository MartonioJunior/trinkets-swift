//
//  Hecto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^2 power for a given value.
public enum Hecto: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 2 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Hecto.Type {
    static var hecto: Self { .init(Hecto.self) }
}
