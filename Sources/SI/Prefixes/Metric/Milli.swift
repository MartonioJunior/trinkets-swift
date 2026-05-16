//
//  Milli.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Milli: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -3 }
}

// MARK: Tagged (EX)
public extension Tagged where Tag == MetricPrefix, RawValue == Milli.Type {
    static var milli: Self { .init(Milli.self) }
}
