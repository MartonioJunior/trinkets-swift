//
//  Giga.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Giga: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 9 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Giga.Type {
    static var giga: Self { .init(Giga.self) }
}
