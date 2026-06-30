//
//  Kilo.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^3 power for a given value.
public enum Kilo: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 3 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Kilo.Type {
    static var kilo: Self { .init(Kilo.self) }
}
