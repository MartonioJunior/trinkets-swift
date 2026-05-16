//
//  Tera.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Tera: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 12 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Tera.Type {
    static var tera: Self { .init(Tera.self) }
}
