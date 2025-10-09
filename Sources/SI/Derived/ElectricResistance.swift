//
//  ElectricResistance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum ElectricResistance: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .ohms
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -3, ElectricCurrent.self: -2]
}

public extension Unit where D == ElectricResistance {
    static let ohms: Self = .init("Ω", details: .base)
}
