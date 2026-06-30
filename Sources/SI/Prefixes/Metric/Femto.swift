//
//  Femto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-15 power for a given value.
public enum Femto: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -15 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Femto.Type {
    static var femto: Self { .init(Femto.self) }
}
