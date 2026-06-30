//
//  Pebi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Pebi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 50 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Pebi.Type {
    static var pebi: Self { .init(Pebi.self) }
}
