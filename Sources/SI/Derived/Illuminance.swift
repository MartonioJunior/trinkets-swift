//
//  Illuminance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Tagged
import TrinketsUnits

public enum Illuminance: Dimension {
    public typealias BaseUnit = Lux

    public static let dimensionality: Dimensionality = [LuminousIntensity.self: 1, SolidAngle.self: 1, Length.self: -2]
}

// MARK: Self.Lux
public extension Illuminance {
    enum Lux: StaticUnit { // 1lm / 1m2
        public typealias Base = Illuminance
    }
}

#if LocalizedSymbols
public extension Illuminance.Lux {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Illuminance.luxSymbol, name: .Illuminance.luxName)
    }
}
#endif

public extension Tagged where Tag == Illuminance.Lux, RawValue: Numeric {
    var illuminance: Self { .init(rawValue) }
}

public extension Tagged where Tag == Illuminance, RawValue: Numeric {
    var lux: Self { .init(rawValue) }
}
