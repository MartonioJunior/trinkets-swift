//
//  ElectricCurrent.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct ElectricCurrent: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .amperes
}

public extension Unit where D == ElectricCurrent {
    static let amperes: Self = .init("A", details: .base)
}
