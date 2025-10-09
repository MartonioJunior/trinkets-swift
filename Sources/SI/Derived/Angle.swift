//
//  Angle.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Angle: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Angle> = .degrees
    public static let dimensionality: Dimensionality = .dimensionless
}

// MARK: Default Units
public extension Unit where D == Angle {
    static let degrees: Self = .init("°", details: .base)
    static let arcMinutes: Self = .init("ʹ", details: .linear(0.016667))
    static let arcSeconds: Self = .init("ʺ", details: .linear(0.00027778))
    static let radians: Self = .init("rad", details: .linear(57.2958)) // 57.29577951308232
    static let gradians: Self = .init("grad", details: .linear(0.9))
    static let revolutions: Self = .init("rev", details: .linear(360))
    static let pi: Self = .init("π", details: .linear(180))

    /// Represents the angle covered by a slice in a circle with equally divided slices
    func circleSliced(in numberOfSlices: Int) -> Self {
        .init("\(numberOfSlices)-sliced", details: .linear(360 / Double(numberOfSlices)))
    }
}
