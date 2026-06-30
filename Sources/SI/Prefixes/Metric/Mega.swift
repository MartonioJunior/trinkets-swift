//
//  Mega.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^6 power for a given value.
public enum Mega: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 6 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Mega.Type {
    static var mega: Self { .init(Mega.self) }
}
