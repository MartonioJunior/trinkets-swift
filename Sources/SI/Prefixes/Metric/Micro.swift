//
//  Micro.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-6 power for a given value.
public enum Micro: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -6 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Micro.Type {
    static var micro: Self { .init(Micro.self) }
}
