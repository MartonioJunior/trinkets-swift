//
//  ElectricResistance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
import TrinketsUnits

public enum ElectricResistance: Dimension {
    public typealias BaseUnit = Ohms

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -3, ElectricCurrent.self: -2]
}

// MARK: Self.Ohms
public extension ElectricResistance {
    enum Ohms: StaticUnit {
        public typealias Base = ElectricResistance
    }
}

#if LocalizedSymbols
public extension ElectricResistance.Ohms {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .ElectricResistance.ohmsSymbol, name: .ElectricResistance.ohmsName)
    }
}
#endif

public extension Tagged where Tag == ElectricResistance.Ohms, RawValue: Numeric {
    var electricResistance: Tagged<ElectricResistance, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ElectricResistance, RawValue: Numeric {
    var ohms: Tagged<ElectricResistance.Ohms, RawValue> { .init(rawValue) }
}
