//
//  Deca.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^1 power for a given value.
public enum Deca: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 1 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Deca.Type {
    static var deca: Self { .init(Deca.self) }
}
