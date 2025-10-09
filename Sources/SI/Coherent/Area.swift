//
//  Area.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import TrinketsUnits

public enum Area: Dimension {
    public typealias Features = LinearConverter
    public typealias Value = Double

    public static let baseUnit: Unit<Area> = .square(.meters)
    public static let dimensionality: Dimensionality = [Length.self: 2]
}

// MARK: Default Units
public extension Unit where D == Area {
    static let acres: Self = .init("ac", details: .linear(4046.86))
    static let ares: Self = .init("ar", details: .linear(100))
    static let hectares: Self = .init("ha", details: .linear(10000))
}

// MARK: Conversions
public extension Area {
    @available(macOS 26.0, *)
    static func `in`(_ exponential: Unit<Exponential<Length, 2>>) -> Unit<Self> {
        let f = exponential.features.unit.features.polynomial
        return .init(exponential.symbol, details: .linear((f * f)[e: 1]))
    }

    static func `in`(_ product: Unit<Product<Length, Length>>) -> Unit<Self> {
        let base = product.features
        let symbol: String = if base.lhs == base.rhs {
            "\(base.lhs.symbol)2"
        } else {
            base.description
        }

        if #available(macOS 26, *) {
            let f = base.lhs.features.polynomial * base.rhs.features.polynomial
            return .init(symbol, details: .linear(f[e: 1]))
        } else {
            return .init(symbol, details: .init(base.lhs.features.coefficient * base.lhs.features.coefficient))
        }
    }
}

public extension Unit where D == Area {
    static func square(_ length: Unit<Length>) -> Self {
        D.in(length * length)
    }
}
