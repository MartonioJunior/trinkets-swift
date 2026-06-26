//
//  Speed.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum Speed: Dimension {
    public typealias BaseUnit = MetersPerSecond

    public static let dimensionality: Dimensionality = [Length.self: 1, Time.self: -1]
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

// MARK: Self.MetersPerSecond
public extension Speed {
    enum MetersPerSecond: StaticUnit {
        public typealias Base = Speed
    }
}

#if LocalizedSymbols
public extension Speed.MetersPerSecond {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.metersPerSecondSymbol, name: SyntaxFunction {
            .Speed.metersPerSecondName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Speed.MetersPerSecond, RawValue: Numeric {
    var speed: Tagged<Speed, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Speed, RawValue: Numeric {
    var metersPerSecond: Tagged<Speed.MetersPerSecond, RawValue> { .init(rawValue) }
}

// MARK: Self.KilometersPerHour
public extension Speed {
    typealias KilometersPerHour = Fraction<PrefixedUnit<Kilo, Length.Meters>, Time.Hours>
}

#if LocalizedSymbols
public extension Speed.KilometersPerHour {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.kilometersPerHourSymbol, name: SyntaxFunction {
            .Speed.kilometersPerHourName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Speed.KilometersPerHour, RawValue: Numeric & ExpressibleByFloatLiteral {
    var speed: Tagged<Speed, RawValue> { .init(rawValue * 0.277778) }
}

public extension Tagged where Tag == Speed, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var kilometersPerHour: Tagged<Speed.KilometersPerHour, RawValue> { .init(rawValue / 0.277778) }
}

// MARK: Self.MilesPerHour
public extension Speed {
    typealias MilesPerHour = Fraction<Length.Miles, Time.Hours>
}

#if LocalizedSymbols
public extension Speed.MilesPerHour {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.milesPerHourSymbol, name: SyntaxFunction {
            .Speed.milesPerHourName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Speed.MilesPerHour, RawValue: Numeric & ExpressibleByFloatLiteral {
    var speed: Tagged<Speed, RawValue> { .init(rawValue * 0.44704) }
}

public extension Tagged where Tag == Speed, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var milesPerHour: Tagged<Speed.MilesPerHour, RawValue> { .init(rawValue / 0.44704) }
}

// MARK: Self.Knots
public extension Speed {
    enum Knots: StaticUnit {
        public typealias Base = Speed
    }
}

#if LocalizedSymbols
public extension Speed.Knots {
    static var symbol: UnitRepresentation {
        .init(symbol: .Speed.knotsSymbol, name: SyntaxFunction {
            .Speed.knotsName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Speed.Knots, RawValue: Numeric & ExpressibleByFloatLiteral {
    var speed: Tagged<Speed, RawValue> { .init(rawValue * 0.514444) }
}

public extension Tagged where Tag == Speed, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var knots: Tagged<Speed.Knots, RawValue> { .init(rawValue / 0.514444) }
}
