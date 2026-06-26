//
//  Capacitance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
import TrinketsUnits

public enum Capacitance: Dimension {
    public typealias BaseUnit = Farad

    public static let dimensionality: Dimensionality = [Mass.self: -1, Length.self: -2, Time.self: 4, ElectricCurrent.self: 2]
}

// MARK: Self.Farad
public extension Capacitance {
    enum Farad: StaticUnit {
        public typealias Base = Capacitance
    }
}

#if LocalizedSymbols
public extension Capacitance.Farad {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Capacitance.faradSymbol, name: .Capacitance.faradName)
    }
}
#endif

public extension Tagged where Tag == Capacitance.Farad, RawValue: Numeric {
    var capacitance: Tagged<Capacitance, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Capacitance, RawValue: Numeric {
    var farad: Tagged<Capacitance.Farad, RawValue> { .init(rawValue) }
}
