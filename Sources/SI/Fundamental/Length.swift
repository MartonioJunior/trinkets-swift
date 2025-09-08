//
//  Length.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import TrinketsUnits

public struct Length: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Length> = .meters
}

// MARK: SI Units
public extension Unit where D == Length {
    static let meters: Self = .init("m", details: .base)
    static let astronomicalUnits: Self = .init("au", details: .linear(149_597_870_700))
}

// MARK: Non-SI Units
public extension Unit where D == Length {
    static let inches: Self = .init("in", details: .linear(0.0254))
    static let feet: Self = .init("ft", details: .linear(0.3048))
    static let yards: Self = .init("yd", details: .linear(0.9144))
    static let miles: Self = .init("mi", details: .linear(1609.344))
    static let scandinavianMiles: Self = .init("smi", details: .linear(10000))
    static let lightYears: Self = .init("ly", details: .linear(9_460_730_472_580_800))
    static let nauticalMiles: Self = .init("NM", details: .linear(1852))
    static let fathoms: Self = .init("ftm", details: .linear(1.8288))
    static let furlongs: Self = .init("fur", details: .linear(201.168))
    static let parsecs: Self = .init("pc", details: .linear(3_085_677_581_410_000))
}
