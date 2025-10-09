//
//  Force.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum Force: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .newtons
    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 1, Time.self: -2]
}

// MARK: SI Units
public extension Unit where D == Force {
    static let newtons: Self = .init("N", details: .base)
}
