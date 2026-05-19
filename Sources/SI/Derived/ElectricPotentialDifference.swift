//
//  ElectricPotentialDifference.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

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

public extension StaticConverter where Origin == ElectricPotentialDifference.Volts, Target == ElectricPotentialDifference, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == ElectricPotentialDifference, Target == ElectricPotentialDifference.Volts, Value: Numeric {
    static var volts: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == ElectricPotentialDifference, RawValue == ElectricPotentialDifference.Volts.Type {
    static var volts: Self { .init(ElectricPotentialDifference.Volts.self) }
}
