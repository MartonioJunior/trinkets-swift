//
//  Peta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^15 power for a given value.
public enum Peta: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 15 }
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
}

public extension Tagged where Tag == MetricPrefix, RawValue == Peta.Type {
    static var peta: Self { .init(Peta.self) }
}
