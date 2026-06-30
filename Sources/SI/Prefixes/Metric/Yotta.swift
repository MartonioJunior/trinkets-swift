//
//  Yotta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^24 power for a given value.
public enum Yotta: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 24 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Yotta.Type {
    static var yotta: Self { .init(Yotta.self) }
}
