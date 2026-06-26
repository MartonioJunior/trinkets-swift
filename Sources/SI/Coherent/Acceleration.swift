//
//  Acceleration.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum Acceleration: Dimension {
    public typealias BaseUnit = Self.MetersPerSecondSquared

    public static let dimensionality: Dimensionality = [Length.self: 1, Time.self: -2]
}

// MARK: Self.MetersPerSecondSquared
public extension Acceleration {
    enum MetersPerSecondSquared: StaticUnit {
        public typealias Base = Acceleration
    }
}

#if LocalizedSymbols
public extension Acceleration.MetersPerSecondSquared {
    static var symbol: UnitRepresentation {
        .init(symbol: .Acceleration.metersPerSecondSquaredSymbol, name: SyntaxFunction {
            .Acceleration.metersPerSecondSquaredName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Acceleration.MetersPerSecondSquared, RawValue: Numeric {
    var acceleration: Tagged<Acceleration, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Acceleration, RawValue: Numeric {
    var metersPerSecondSquared: Tagged<Acceleration.MetersPerSecondSquared, RawValue> { .init(rawValue) }
}

// MARK: Self.Gravity
public extension Acceleration {
    enum Gravity: StaticUnit {
        public typealias Base = Acceleration
    }
}

#if LocalizedSymbols
public extension Acceleration.Gravity {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Acceleration.gravitySymbol, name: .Acceleration.gravityName)
    }
}
#endif

public extension Tagged where Tag == Acceleration.Gravity, RawValue: Numeric & ExpressibleByFloatLiteral {
    var acceleration: Tagged<Acceleration, RawValue> { .init(rawValue * 9.81) }
}

public extension Tagged where Tag == Acceleration, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var gravity: Tagged<Acceleration.Gravity, RawValue> { .init(rawValue / 9.81) }
}
