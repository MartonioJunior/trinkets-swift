//
//  Duration.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Time: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Time> = .seconds
}

// MARK: Default Units
public extension Unit where D == Time {
    static let seconds: Self = .init("sec", details: .base)
    static let minutes: Self = .init("min", details: .linear(60))
    static let hours: Self = .init("hr", details: .linear(3600))
    static let days: Self = .init("d", details: .linear(86400))
}

// MARK: Measurement (EX)
public extension Measurement where UnitType == Unit<Time> {
    init(_ duration: Duration) {
        let v = duration.components
        let fractional = Double(v.attoseconds) * 10e-19
        let durationAsDouble = Double(v.seconds) + fractional
        self.init(durationAsDouble, .seconds)
    }

    var asDuration: Duration { .seconds(baseValue) }
}
