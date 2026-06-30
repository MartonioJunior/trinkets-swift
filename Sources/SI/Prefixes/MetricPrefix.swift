//
//  MetricPrefix+SI.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
import TrinketsUnits

public enum MetricPrefix {}

// MARK: Self: PrefixBase
extension MetricPrefix: UnitPrefixSystem {
    public static var base: Int { 10 }
}
