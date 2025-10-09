//
//  Acceleration.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Acceleration: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Acceleration> = .metersPerSecondSquared
    public static let dimensionality: Dimensionality = [Length.self: 1, Time.self: -2]
}

// MARK: Default Units
public extension Unit where D == Acceleration {
    static let metersPerSecondSquared: Self = .init("m/s²", details: .base)
    static let gravity: Self = .init("g", details: .linear(9.81))
}
