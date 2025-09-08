//
//  ElectricCharge.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct ElectricCharge: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .coulombs
    public static let dimensionality: Dimensionality = [ElectricCurrent.self: 1, Time.self: 1]
}

// MARK: Default Units
public extension Unit where D == ElectricCharge {
    static let coulombs: Self = .init("C", details: .base)
    static let ampereHours: Self = .init("Ah", details: .linear(3600))
}
