//
//  Kilo.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Kilo: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 3 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Kilo.Type {
    static var kilo: Self { .init(Kilo.self) }
}
