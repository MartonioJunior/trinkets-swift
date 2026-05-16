//
//  Ronto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Ronto: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -27 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Ronto.Type {
    static var ronto: Self { .init(Ronto.self) }
}
