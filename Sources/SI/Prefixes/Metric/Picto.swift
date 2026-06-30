//
//  Picto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-12 power for a given value.
public enum Picto: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -12 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Picto.Type {
    static var picto: Self { .init(Picto.self) }
}
