//
//  Frequency.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Frequency: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Frequency> = .hertz
    public static let dimensionality: Dimensionality = [Time.self: -1]
}

// MARK: Default Units
public extension Unit where D == Frequency {
    static let hertz: Self = .init("hz", details: .base)
}
