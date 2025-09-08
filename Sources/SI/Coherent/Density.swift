//
//  Density.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct Density: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .kilogramsPerCubicMeter
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: -3]
}

// MARK: SI Units
public extension Unit where D == Density {
    static let kilogramsPerCubicMeter: Self = .init("kg/m3", details: .base)
    static let gramsPerLiter: Self = .init("g/L", details: .base)
    static let milligramsPerDeciliter: Self = .init("mg/dL", details: .linear(0.01))

    static func millimolesPerLiter(withGramsPerMole gramsPerMole: Double) -> Self {
        .init("mmol/L", details: .linear(18 * gramsPerMole))
    }
}

// MARK: Mass (EX)
public extension Mass {
    typealias Concentration = Density
}
