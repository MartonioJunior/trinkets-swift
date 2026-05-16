//
//  Exa.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Exa: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 18 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Exa.Type {
    static var exa: Self { .init(Exa.self) }
}
