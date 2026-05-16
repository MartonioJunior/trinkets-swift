//
//  Picto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Picto: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -12 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Picto.Type {
    static var picto: Self { .init(Picto.self) }
}
