//
//  Power.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public typealias RadiantFlux = Power

public enum Power: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Power> = .watts
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -3]
}

// MARK: Default Units
public extension Unit where D == Power {
    static let watts: Self = .init("W", details: .base)
    static let horsepower: Self = .init("hp", details: .linear(745.7))
}
