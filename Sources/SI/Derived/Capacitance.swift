//
//  Capacitance.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

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

public extension Capacitance.Farad {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Capacitance.faradSymbol, name: .Capacitance.faradName)
    }
}

public extension StaticConverter where Origin == Capacitance.Farad, Target == Capacitance, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Capacitance, Target == Capacitance.Farad, Value: Numeric {
    static var farad: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Capacitance, RawValue == Capacitance.Farad.Type {
    static var farad: Self { .init(Capacitance.Farad.self) }
}
