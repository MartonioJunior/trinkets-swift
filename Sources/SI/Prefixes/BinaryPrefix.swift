//
//  MetricPrefix+Binary.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum BinaryPrefix {}

// MARK: Self: PrefixBase
extension BinaryPrefix: UnitPrefixSystem {
    public static var base: Int { 2 }
}

// TODO: Add the units below for localization
// public extension MetricPrefix {
//     static let yobi: Self = .init(symbol: "Yi", 2, e: 80)
//     static let zebi: Self = .init(symbol: "Zi", 2, e: 70)
//     static let exbi: Self = .init(symbol: "Ei", 2, e: 60)
//     static let pebi: Self = .init(symbol: "Pi", 2, e: 50)
//     static let tebi: Self = .init(symbol: "Ti", 2, e: 40)
//     static let gibi: Self = .init(symbol: "Gi", 2, e: 30)
//     static let mebi: Self = .init(symbol: "Mi", 2, e: 20)
//     static let kibi: Self = .init(symbol: "Ki", 2, e: 10)
// }
