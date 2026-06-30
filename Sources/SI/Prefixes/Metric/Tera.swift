//
//  Tera.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^12 power for a given value.
public enum Tera: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 12 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Tera.Type {
    static var tera: Self { .init(Tera.self) }
}
