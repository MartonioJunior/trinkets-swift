//
//  Peta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Peta: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 15 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Peta.Type {
    static var peta: Self { .init(Peta.self) }
}
