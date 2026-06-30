//
//  Mibi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Mibi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 20 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Mibi.Type {
    static var mibi: Self { .init(Mibi.self) }
}
