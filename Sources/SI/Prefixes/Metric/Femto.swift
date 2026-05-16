//
//  Femto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Femto: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -15 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Femto.Type {
    static var femto: Self { .init(Femto.self) }
}
