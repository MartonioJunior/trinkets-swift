//
//  Illuminance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Illuminance: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Illuminance> = .lux
    public static let dimensionality: Dimensionality = [LuminousIntensity.self: 1, SolidAngle.self: 1, Length.self: -2]
}

// MARK: Default Units
public extension Unit where D == Illuminance {
    static let lux: Self = .init("lx", details: .base) // 1lm / 1m2
}
