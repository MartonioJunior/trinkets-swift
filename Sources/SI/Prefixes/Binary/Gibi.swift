//
//  Gibi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Gibi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 30 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Gibi.Type {
    static var gibi: Self { .init(Gibi.self) }
}