//
//  Mass.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Mass: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Mass> = .init(.kilo, .grams)
}

// MARK: SI Units
public extension Unit where D == Mass {
    static let grams: Self = .init("g", details: .linear(0.001))
    static let metricTons: Self = .init("t", details: .linear(1000))
}

// MARK: Non-SI Units
public extension Unit where D == Mass {
    static let ounces: Self = .init("oz", details: .linear(0.0283495))
    static let pounds: Self = .init("lb", details: .linear(0.453592))
    static let stones: Self = .init("st", details: .linear(0.157473))
    static let shortTons: Self = .init("ton", details: .linear(907.185))
    static let carats: Self = .init("ct", details: .linear(0.0002))
    static let ouncesTroy: Self = .init("oz t", details: .linear(0.03110348))
    static let slugs: Self = .init("slug", details: .linear(14.5939))
}
