//
//  Deci.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Deci: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -1 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Deci.Type {
    static var deci: Self { .init(Deci.self) }
}
