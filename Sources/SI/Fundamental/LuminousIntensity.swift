//
//  LuminousIntensity.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct LuminousIntensity: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .candela
}

// MARK: SI Units
public extension Unit where D == LuminousIntensity {
    static let candela: Self = .init("cd", details: .base)
}
