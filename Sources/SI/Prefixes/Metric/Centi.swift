//
//  Centi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Centi: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -2 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Centi.Type {
    static var centi: Self { .init(Centi.self) }
}
