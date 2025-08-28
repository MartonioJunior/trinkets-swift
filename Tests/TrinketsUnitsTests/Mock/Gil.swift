//
//  GilDimension.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/06/25.
//

import TrinketsUnits

public struct Gil {}

// MARK: Self: Dimension
extension Gil: Dimension {
    public typealias Features = LinearConverter

    public static let baseUnit: Unit<Gil> = .gil
}

// MARK: Example Units
public extension Unit where D == Gil {
    static let gil: Self = .init("g", details: .base)
    static let linen: Self = .init("ln", details: .linear(2, k: 7))
    static let zeni: Self = .init("z", details: .linear(3))
}
