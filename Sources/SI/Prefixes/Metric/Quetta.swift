//
//  Quetta.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/04/2026.
//

import Tagged
import TrinketsUnits

public enum Quetta: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 30 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Quetta.Type {
    static var quetta: Self { .init(Quetta.self) }
}
