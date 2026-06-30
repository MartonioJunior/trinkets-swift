//
//  Yobi.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/06/2026.
//

import Tagged
import TrinketsUnits

public enum Yobi: UnitPrefix {
    // swiftlint:disable:next missing_docs
    public typealias Base = BinaryPrefix
    // swiftlint:disable:next missing_docs
    public static var exponent: Int { 80 }
}

public extension Tagged where Tag == BinaryPrefix, RawValue == Yobi.Type {
    static var yobi: Self { .init(Yobi.self) }
}
