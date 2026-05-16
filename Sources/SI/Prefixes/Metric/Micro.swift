//
//  Micro.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Micro: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -6 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Micro.Type {
    static var micro: Self { .init(Micro.self) }
}
