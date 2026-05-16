//
//  ElectricCharge.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import TrinketsUnits

public enum ElectricCharge: Dimension {
    public typealias BaseUnit = Coulombs

    public static let dimensionality: Dimensionality = [ElectricCurrent.self: 1, Time.self: 1]
}

// MARK: Self.Coulombs
public extension ElectricCharge {
    enum Coulombs: StaticUnit {
        public typealias Base = ElectricCharge
    }
}

public extension ElectricCharge.Coulombs {
    static var symbol: UnitRepresentation {
        .init(symbol: .ElectricCharge.coulombsSymbol, name: SyntaxFunction {
            .ElectricCharge.coulombsName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == ElectricCharge.Coulombs, Target == ElectricCharge, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == ElectricCharge, Target == ElectricCharge.Coulombs, Value: Numeric {
    static var coulombs: Self { .init { $0 } }
}

// MARK: Self.AmpereHours
public extension ElectricCharge {
    typealias AmpereHours = Product<ElectricCurrent.Amperes, Time.Hours>
}

public extension ElectricCharge.AmpereHours {
    static var symbol: UnitRepresentation {
        .init(symbol: .ElectricCharge.ampereHoursSymbol, name: SyntaxFunction {
            .ElectricCharge.ampereHoursName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == ElectricCharge.AmpereHours, Target == ElectricCharge, Value: Numeric {
    static var to: Self { .init { $0 * 3600 } }
}

public extension StaticConverter where Origin == ElectricCharge, Target == ElectricCharge.AmpereHours, Value: FloatingPoint {
    static var ampereHours: Self { .init { $0 / 3600 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == ElectricCharge, RawValue == ElectricCharge.Coulombs.Type {
    static var coulombs: Self { .init(ElectricCharge.Coulombs.self) }
}

public extension Tagged where Tag == ElectricCharge, RawValue == ElectricCharge.AmpereHours.Type {
    static var ampereHours: Self { .init(ElectricCharge.AmpereHours.self) }
}

public extension Tagged where Tag == Product<ElectricCharge, Time> {
    var asElectricCharge: Tagged<ElectricCharge, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Time, ElectricCharge> {
    var asElectricCharge: Tagged<ElectricCharge, RawValue> { .init(rawValue) }
}
