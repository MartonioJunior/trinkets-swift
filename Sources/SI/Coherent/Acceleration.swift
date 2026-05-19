//
//  Acceleration.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
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

public extension StaticConverter where Origin == Acceleration.MetersPerSecondSquared, Target == Acceleration, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Acceleration, Target == Acceleration.MetersPerSecondSquared, Value: Numeric {
    static var metersPerSecondSquared: Self { .init { $0 } }
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

public extension StaticConverter where Origin == Acceleration.Gravity, Target == Acceleration, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 9.81 } }
}

public extension StaticConverter where Origin == Acceleration, Target == Acceleration.Gravity, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var gravity: Self { .init { $0 / 9.81 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Acceleration, RawValue == Acceleration.MetersPerSecondSquared.Type {
    static var metersPerSecondSquared: Self { .init(Acceleration.MetersPerSecondSquared.self) }
}

public extension Tagged where Tag == Acceleration, RawValue == Acceleration.Gravity.Type {
    static var gravity: Self { .init(Acceleration.Gravity.self) }
}
