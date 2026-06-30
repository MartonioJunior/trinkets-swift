//
//  Tebi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Tebi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 40 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Tebi.Type {
    static var tebi: Self { .init(Tebi.self) }
}
