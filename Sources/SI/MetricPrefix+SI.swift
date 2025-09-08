//
//  MetricPrefix+SI.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public extension MetricPrefix {
    static let quetta: Self = .init(symbol: "Q", e: 30)
    static let ronna: Self = .init(symbol: "R", e: 27)
    static let yotta: Self = .init(symbol: "Y", e: 24)
    static let zetta: Self = .init(symbol: "Z", e: 21)
    static let exa: Self = .init(symbol: "E", e: 18)
    static let peta: Self = .init(symbol: "P", e: 15)
    static let tera: Self = .init(symbol: "T", e: 12)
    static let giga: Self = .init(symbol: "G", e: 9)
    static let mega: Self = .init(symbol: "M", e: 6)
    static let kilo: Self = .init(symbol: "k", e: 3)
    static let hecto: Self = .init(symbol: "h", e: 2)
    static let deca: Self = .init(symbol: "d", e: 1)
    static let deci: Self = .init(symbol: "da", e: -1)
    static let centi: Self = .init(symbol: "c", e: -2)
    static let milli: Self = .init(symbol: "m", e: -3)
    static let micro: Self = .init(symbol: "μ", e: -6)
    static let nano: Self = .init(symbol: "ν", e: -9)
    static let pico: Self = .init(symbol: "π", e: -12)
    static let femto: Self = .init(symbol: "f", e: -15)
    static let atto: Self = .init(symbol: "a", e: -18)
    static let zepto: Self = .init(symbol: "z", e: -21)
    static let yocto: Self = .init(symbol: "y", e: -24)
    static let ronto: Self = .init(symbol: "r", e: -27)
    static let quecto: Self = .init(symbol: "q", e: -30)
}
