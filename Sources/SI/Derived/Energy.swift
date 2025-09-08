//
//  Energy.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public typealias Work = Energy
public typealias HeatAmount = Energy

public struct Energy: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Energy> = .joules
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -2]
}

// MARK: Default Units
public extension Unit where D == Energy {
    static let joules: Self = .init("J", details: .base)
    static let calories: Self = .init("cal", details: .linear(4.184))
    static let milliwattHours: Self = .init("mWh", details: .linear(3.6))
    static let kilowattHours: Self = .init("kWh", details: .linear(3_600_000))
}
