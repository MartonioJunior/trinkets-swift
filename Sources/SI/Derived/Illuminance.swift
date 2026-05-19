//
//  Illuminance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

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

public extension StaticConverter where Origin == Illuminance.Lux, Target == Illuminance, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Illuminance, Target == Illuminance.Lux, Value: Numeric {
    static var lux: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Illuminance, RawValue == Illuminance.Lux.Type {
    static var lux: Self { .init(Illuminance.Lux.self) }
}
