//
//  Speed.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import TrinketsUnits

public enum Speed: Dimension {
    public typealias BaseUnit = MetersPerSecond

    public static let dimensionality: Dimensionality = [Length.self: 1, Time.self: -1]
}

// MARK: Self.MetersPerSecond
public extension Speed {
    enum MetersPerSecond: StaticUnit {
        public typealias Base = Speed
    }
}

public extension Speed.MetersPerSecond {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.metersPerSecondSymbol, name: SyntaxFunction {
            .Speed.metersPerSecondName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Speed.MetersPerSecond, Target == Speed, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Speed, Target == Speed.MetersPerSecond, Value: Numeric {
    static var metersPerSecond: Self { .init { $0 } }
}

// MARK: Self.KilometersPerHour
public extension Speed {
    typealias KilometersPerHour = Fraction<PrefixedUnit<Kilo, Length.Meters>, Time.Hours>
}

public extension Speed.KilometersPerHour {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.kilometersPerHourSymbol, name: SyntaxFunction {
            .Speed.kilometersPerHourName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Speed.KilometersPerHour, Target == Speed, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.277778 } }
}

public extension StaticConverter where Origin == Speed, Target == Speed.KilometersPerHour, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var kilometersPerHour: Self { .init { $0 / 0.277778 } }
}

// MARK: Self.MilesPerHour
public extension Speed {
    typealias MilesPerHour = Fraction<Length.Miles, Time.Hours>
}

public extension Speed.MilesPerHour {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.milesPerHourSymbol, name: SyntaxFunction {
            .Speed.milesPerHourName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Speed.MilesPerHour, Target == Speed, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.44704 } }
}

public extension StaticConverter where Origin == Speed, Target == Speed.MilesPerHour, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var milesPerHour: Self { .init { $0 / 0.44704 } }
}

// MARK: Self.Knots
public extension Speed {
    enum Knots: StaticUnit {
        public typealias Base = Speed
    }
}

public extension Speed.Knots {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.knotsSymbol, name: SyntaxFunction {
            .Speed.knotsName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Speed.Knots, Target == Speed, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.514444 } }
}

public extension StaticConverter where Origin == Speed, Target == Speed.Knots, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var knots: Self { .init { $0 / 0.514444 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Speed, RawValue == Speed.MetersPerSecond.Type {
    static var metersPerSecond: Self { .init(Speed.MetersPerSecond.self) }
}

public extension Tagged where Tag == Speed, RawValue == Speed.KilometersPerHour.Type {
    static var kilometersPerHour: Self { .init(Speed.KilometersPerHour.self) }
}

public extension Tagged where Tag == Speed, RawValue == Speed.MilesPerHour.Type {
    static var milesPerHour: Self { .init(Speed.MilesPerHour.self) }
}

public extension Tagged where Tag == Speed, RawValue == Speed.Knots.Type {
    static var knots: Self { .init(Speed.Knots.self) }
}

public extension Tagged where Tag == Fraction<Length, Time> {
    var asSpeed: Tagged<Speed, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Acceleration, Time> {
    var asSpeed: Tagged<Speed, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Time, Acceleration> {
    var asSpeed: Tagged<Speed, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Fraction<Length.Meters, Time.Seconds> {
    var asSpeed: Tagged<Speed.MetersPerSecond, RawValue> { .init(rawValue) }
}
