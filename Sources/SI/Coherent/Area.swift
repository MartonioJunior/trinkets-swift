//
//  Area.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import TrinketsUnits

public struct Area: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Area> = .square(.meters)
    public static let dimensionality: Dimensionality = [Length.self: 2]
}

// MARK: Default Units
public extension Unit where D == Area {
    static let acres: Self = .init("ac", details: .linear(4046.86))
    static let ares: Self = .init("ar", details: .linear(100))
    static let hectares: Self = .init("ha", details: .linear(10000))
}

