//
//  Quecto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Quecto: UnitPrefix {
    public typealias Base = MetricPrefix

    public static var exponent: Int { -30 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Quecto.Type {
    static var quecto: Self { .init(Quecto.self) }
}
