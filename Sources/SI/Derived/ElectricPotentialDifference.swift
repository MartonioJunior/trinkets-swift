//
//  ElectricPotentialDifference.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct ElectricPotentialDifference: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .volts
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -3, ElectricCurrent.self: -1]
}

// MARK: Default Units
public extension Unit where D == ElectricPotentialDifference {
    static let volts: Self = .init("V", details: .base)
}
