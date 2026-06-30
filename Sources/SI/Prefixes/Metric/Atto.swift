//
//  Atto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-18 power for a given value.
public enum Atto: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -18 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Atto.Type {
    static var atto: Self { .init(Atto.self) }
}
