//
//  ElectricPotentialDifference.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
import TrinketsUnits

public enum ElectricPotentialDifference: Dimension {
    public typealias BaseUnit = Volts

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -3, ElectricCurrent.self: -1]
}

// MARK: Self.Volts
public extension ElectricPotentialDifference {
    enum Volts: StaticUnit {
        public typealias Base = ElectricPotentialDifference
    }
}

#if LocalizedSymbols
public extension ElectricPotentialDifference.Volts {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .ElectricPotentialDifference.voltsSymbol, name: .ElectricPotentialDifference.voltsName)
    }
}
#endif

public extension Tagged where Tag == ElectricPotentialDifference.Volts, RawValue: Numeric {
    var electricPotentialDifference: Tagged<ElectricPotentialDifference, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ElectricPotentialDifference, RawValue: Numeric {
    var volts: Tagged<ElectricPotentialDifference.Volts, RawValue> { .init(rawValue) }
}
