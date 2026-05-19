//
//  ElectricResistance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

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

public extension StaticConverter where Origin == ElectricResistance.Ohms, Target == ElectricResistance, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == ElectricResistance, Target == ElectricResistance.Ohms, Value: Numeric {
    static var ohms: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == ElectricResistance, RawValue == ElectricResistance.Ohms.Type {
    static var ohms: Self { .init(ElectricResistance.Ohms.self) }
}
