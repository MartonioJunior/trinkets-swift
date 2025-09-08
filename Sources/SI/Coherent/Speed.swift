//
//  Speed.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public struct Speed: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Speed> = .metersPerSecond
    public static let dimensionality: Dimensionality = [Length.self: 1, Time.self: -1]
}

// MARK: Default Units
public extension Unit where D == Speed {
    static let metersPerSecond: Self = .init("m/s", details: .base)
    static let kilometersPerHour: Self = .init("km/h", details: .linear(0.277778))
    static let milesPerHour: Self = .init("mph", details: .linear(0.44704))
    static let knots: Self = .init("kn", details: .linear(0.514444))
}
