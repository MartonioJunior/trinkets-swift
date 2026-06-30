//
//  Kibi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Kibi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 10 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Kibi.Type {
    static var kibi: Self { .init(Kibi.self) }
}
