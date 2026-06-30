//
//  MetricPrefix+Binary.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum BinaryPrefix {}

// MARK: Self: PrefixBase
extension BinaryPrefix: PrefixBase {
    public static var base: Int { 2 }
}
