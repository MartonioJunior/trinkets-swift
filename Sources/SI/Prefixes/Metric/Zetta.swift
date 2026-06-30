//
//  Zetta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^21 power for a given value.
public enum Zetta: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 21 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Zetta.Type {
    static var zetta: Self { .init(Zetta.self) }
}
