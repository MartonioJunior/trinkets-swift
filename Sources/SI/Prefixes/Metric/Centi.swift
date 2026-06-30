//
//  Centi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-2 power for a given value.
public enum Centi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -2 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Centi.Type {
    static var centi: Self { .init(Centi.self) }
}
