//
//  Capacitance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum Capacitance: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .farad
    public static let dimensionality: Dimensionality = [Mass.self: -1, Length.self: -2, Time.self: 4, ElectricCurrent.self: 2]
}

// MARK: SI Units
public extension Unit where D == Capacitance {
    static let farad: Self = .init("F", details: .base)
}
