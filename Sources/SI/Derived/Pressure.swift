//
//  Pressure.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public typealias Stress = Pressure

public enum Pressure: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Pressure> = .pascals
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: -1, Time.self: -2]
}

// MARK: Default Units
public extension Unit where D == Pressure {
    static let pascals: Self = .init("Pa", details: .base)
    static let newtonsPerMetersSquared: Self = .init("N/m²", details: .base)
    static let bars: Self = .init("bar", details: .linear(100_000))
    static let inchesOfMercury: Self = .init("inHg", details: .linear(3386.39))
    static let millimetersOfMercury: Self = .init("mmHg", details: .linear(133.322))
    static let poundsForcePerSquareInch: Self = .init("psi", details: .linear(6894.76))
}
