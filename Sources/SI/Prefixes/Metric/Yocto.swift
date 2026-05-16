//
//  Yocto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Yocto: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -24 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Yocto.Type {
    static var yocto: Self { .init(Yocto.self) }
}
