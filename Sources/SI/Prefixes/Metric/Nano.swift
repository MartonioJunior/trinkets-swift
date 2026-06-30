//
//  Nano.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-9 power for a given value.
public enum Nano: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -9 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Nano.Type {
    static var nano: Self { .init(Nano.self) }
}
