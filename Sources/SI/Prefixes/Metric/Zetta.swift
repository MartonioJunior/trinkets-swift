//
//  Zetta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Zetta: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 21 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Zetta.Type {
    static var zetta: Self { .init(Zetta.self) }
}
