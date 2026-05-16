//
//  Mega.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Mega: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 6 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Mega.Type {
    static var mega: Self { .init(Mega.self) }
}
