//
//  Hecto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Hecto: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { 2 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Hecto.Type {
    static var hecto: Self { .init(Hecto.self) }
}
