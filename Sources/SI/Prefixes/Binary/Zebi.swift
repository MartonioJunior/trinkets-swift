//
//  Zebi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Zebi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 70 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Zebi.Type {
    static var zebi: Self { .init(Zebi.self) }
}
