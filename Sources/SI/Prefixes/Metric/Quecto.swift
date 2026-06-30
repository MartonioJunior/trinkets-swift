//
//  Quecto.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

/// Prefix representing 10^-30 power for a given value.
public enum Quecto: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -30 }
}

public extension Tagged where Tag == MetricPrefix, RawValue == Quecto.Type {
    static var quecto: Self { .init(Quecto.self) }
}
