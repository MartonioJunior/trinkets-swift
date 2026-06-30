//
//  Quetta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^30 power for a given value.
public enum Quetta: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 30 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Quetta.Type {
    static var quetta: Self { .init(Quetta.self) }
}
