//
//  Exbi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Exbi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 60 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Exbi.Type {
    static var exbi: Self { .init(Exbi.self) }
}
