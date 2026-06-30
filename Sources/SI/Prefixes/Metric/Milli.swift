//
//  Milli.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

import Tagged
import TrinketsUnits

public enum Milli: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = MetricPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { -3 }
}

// MARK: Tagged (EX)
public extension Tagged where Tag == MetricPrefix, RawValue == Milli.Type {
    static var milli: Self { .init(Milli.self) }
}
