//
//  RefreshRate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct RefreshRate {}

// MARK: Self: Dimension
extension RefreshRate: Dimension {
    public typealias Features = LinearConverter

    public static let baseUnit: Unit = .fps
}

// MARK: Default Units
public extension Unit where D == RefreshRate {
    static let fps: Self = .init("fps", details: .base)
    static let cinema: Self = .init("24fps", details: .linear(24))
}
