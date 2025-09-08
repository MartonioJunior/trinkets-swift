//
//  SolidAngle.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct SolidAngle: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .steradians
    public static let dimensionality: Dimensionality = .dimensionless
}

// MARK: Default Units
public extension Unit where D == SolidAngle {
    static let steradians: Self = .init("sr", details: .base)
}
