//
//  Nano.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Nano: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -9 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Nano.Type {
    static var nano: Self { .init(Nano.self) }
}
