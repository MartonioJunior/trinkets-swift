//
//  Temperature.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Temperature: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Temperature> = .kelvin
}

// MARK: Default Units
public extension Unit where D == Temperature {
    static let kelvin: Self = .init("K", details: .base)
    static let celsius: Self = .init("°C", details: .linear(1, k: 273.15))
}

// MARK: Non-SI Units
public extension Unit where D == Temperature {
    static let fahrenheit: Self = .init("°F", details: .linear(0.55555555555556, k: 255.37222222222427))
}
