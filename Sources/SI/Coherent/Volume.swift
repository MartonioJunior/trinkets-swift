//
//  Volume.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public struct Volume: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Volume> = .cubicMeters
    public static let dimensionality: Dimensionality = [Length.self: 3]
}

// MARK: Default Units
public extension Unit where D == Volume {
    // static func cubic(_ unit: Unit<Length>) -> Self {}
    static let cubicMeters: Self = .init("m3", details: .base)
    static let liters: Self = .init("l", details: .linear(0.001))
    static let acreFeet: Self = .init("af", details: .linear(1_233))
    static let bushels: Self = .init("bsh", details: .linear(0.0352391))
    static let teaSpoons: Self = .init("tsp", details: .linear(0.00000492892))
    static let tableSpoons: Self = .init("tbsp", details: .linear(0.0000147868))
    static let fluidOunces: Self = .init("fl oz", details: .linear(0.0000295735))
    static let cups: Self = .init("cup", details: .linear(0.00024))
    static let pints: Self = .init("pt", details: .linear(0.000473176))
    static let quarts: Self = .init("qt", details: .linear(0.000946353))
    static let gallons: Self = .init("gal", details: .linear(0.00378541))
    static let imperialTeaspoons: Self = .init("tsp", details: .linear(0.00000591939))
    static let imperialTablespoons: Self = .init("tbsp", details: .linear(0.0000177582))
    static let imperialFluidOunces: Self = .init("fl oz", details: .linear(0.0000284131))
    static let imperialPints: Self = .init("pt", details: .linear(0.000568261))
    static let imperialQuarts: Self = .init("qt", details: .linear(0.00113652))
    static let imperialGallons: Self = .init("gal", details: .linear(0.00454609))
    static let metricCups: Self = .init("metric cup", details: .linear(0.00025))
}
