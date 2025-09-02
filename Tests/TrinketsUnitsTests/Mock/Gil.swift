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
    public typealias Value = Double

    public static let baseUnit: Unit<Gil> = .gil
}

// MARK: Example Units
public extension Measurable where Self == Unit<Gil> {
    static var gil: Self { .init("g", details: .base) }
    static var linen: Self { .init("ln", details: .linear(2, k: 7)) }
    static var zeni: Self { .init("z", details: .linear(3)) }
    static var zero: Self { .init("0", details: .linear(0)) }

    static func constant(_ k: Value = 1) -> Self {
        .init("k!", details: .linear(0, k: k))
    }
}
