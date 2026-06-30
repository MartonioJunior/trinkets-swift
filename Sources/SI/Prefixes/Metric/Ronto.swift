//
//  Ronto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-27 power for a given value.
public enum Ronto: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -27 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Ronto.Type {
    static var ronto: Self { .init(Ronto.self) }
}
