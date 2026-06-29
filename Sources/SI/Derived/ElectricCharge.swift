//
//  ElectricCharge.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum ElectricCharge: Dimension {
    public typealias BaseUnit = Coulombs

    public static let dimensionality: Dimensionality = [ElectricCurrent.self: 1, Time.self: 1]
}

public extension Tagged where Tag == ProductUnit<ElectricCharge, Time> {
    var asElectricCharge: Tagged<ElectricCharge, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ProductUnit<Time, ElectricCharge> {
    var asElectricCharge: Tagged<ElectricCharge, RawValue> { .init(rawValue) }
}

// MARK: Self.Coulombs
public extension ElectricCharge {
    enum Coulombs: StaticUnit {
        public typealias Base = ElectricCharge
    }
}

#if LocalizedSymbols
public extension ElectricCharge.Coulombs {
    static var symbol: UnitRepresentation {
        .init(symbol: .ElectricCharge.coulombsSymbol, name: SyntaxFunction {
            .ElectricCharge.coulombsName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == ElectricCharge.Coulombs, RawValue: Numeric {
    var electricCharge: Tagged<ElectricCharge, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ElectricCharge, RawValue: Numeric {
    var coulombs: Tagged<ElectricCharge.Coulombs, RawValue> { .init(rawValue) }
}

// MARK: Self.AmpereHours
public extension ElectricCharge {
    typealias AmpereHours = ProductUnit<ElectricCurrent.Amperes, Time.Hours>
}

#if LocalizedSymbols
public extension ElectricCharge.AmpereHours {
    static var symbol: UnitRepresentation {
        .init(symbol: .ElectricCharge.ampereHoursSymbol, name: SyntaxFunction {
            .ElectricCharge.ampereHoursName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == ElectricCharge.AmpereHours, RawValue: Numeric {
    var electricCharge: Tagged<ElectricCharge, RawValue> { .init(rawValue * 3600) }
}

public extension Tagged where Tag == ElectricCharge, RawValue: FloatingPoint {
    var ampereHours: Tagged<ElectricCharge.AmpereHours, RawValue> { .init(rawValue / 3600) }
}
