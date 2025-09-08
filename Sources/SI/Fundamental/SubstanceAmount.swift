//
//  SubstanceAmount.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct SubstanceAmount: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit = .moles
}

// MARK: SI Units
public extension Unit where D == SubstanceAmount {
    static let moles: Self = .init("mol", details: .base)
}
