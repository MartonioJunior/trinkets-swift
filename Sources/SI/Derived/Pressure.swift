//
//  Pressure.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
import TrinketsUnits

public typealias Stress = Pressure

public enum Pressure: Dimension {
    public typealias BaseUnit = Pascals

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: -1, Time.self: -2]
}

public extension Tagged where Tag == FractionUnit<Force, Area> {
    var asPressure: Tagged<Pressure, RawValue> { .init(rawValue) }
}

// MARK: Self.Pascals
public extension Pressure {
    enum Pascals: StaticUnit {
        public typealias Base = Pressure
    }
}

#if LocalizedSymbols
public extension Pressure.Pascals {
    static var symbol: UnitRepresentation {
        .init(symbol: .Pressure.pascalsSymbol, name: SyntaxFunction {
            .Pressure.pascalsName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Pressure.Pascals, RawValue: Numeric {
    var pressure: Tagged<Pressure, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Pressure, RawValue: Numeric {
    var pascals: Tagged<Pressure.Pascals, RawValue> { .init(rawValue) }
}

// MARK: Self.NewtonsPerMetersSquared
public extension Pressure {
    typealias NewtonsPerMetersSquared = FractionUnit<Force.Newtons, Area.SquareMeters>
}

#if LocalizedSymbols
public extension Pressure.NewtonsPerMetersSquared {
    static var symbol: UnitRepresentation {
        .init(symbol: .Pressure.newtonsPerMetersSquaredSymbol, name: SyntaxFunction {
            .Pressure.newtonsPerMetersSquaredName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Pressure.NewtonsPerMetersSquared, RawValue: Numeric {
    var pressure: Tagged<Pressure, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Pressure, RawValue: Numeric {
    var newtonsPerMetersSquared: Tagged<Pressure.NewtonsPerMetersSquared, RawValue> { .init(rawValue) }
}

// MARK: Self.Bars
public extension Pressure {
    enum Bars: StaticUnit {
        public typealias Base = Pressure
    }
}

#if LocalizedSymbols
public extension Pressure.Bars {
    static var symbol: UnitRepresentation {
        .init(symbol: .Pressure.barsSymbol, name: SyntaxFunction {
            .Pressure.barsName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Pressure.Bars, RawValue: Numeric {
    var pressure: Tagged<Pressure, RawValue> { .init(rawValue * 100_000) }
}

public extension Tagged where Tag == Pressure, RawValue: FloatingPoint {
    var bars: Tagged<Pressure.Bars, RawValue> { .init(rawValue / 100_000) }
}

// MARK: Self.InchesOfMercury
public extension Pressure {
    enum InchesOfMercury: StaticUnit {
        public typealias Base = Pressure
    }
}

#if LocalizedSymbols
public extension Pressure.InchesOfMercury {
    static var symbol: UnitRepresentation {
        .init(symbol: .Pressure.inchesOfMercurySymbol, name: SyntaxFunction {
            .Pressure.inchesOfMercuryName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Pressure.InchesOfMercury, RawValue: Numeric & ExpressibleByFloatLiteral {
    var pressure: Tagged<Pressure, RawValue> { .init(rawValue * 3386.39) }
}

public extension Tagged where Tag == Pressure, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var inchesOfMercury: Tagged<Pressure.InchesOfMercury, RawValue> { .init(rawValue / 3386.39) }
}

// MARK: Self.MillimetersOfMercury
public extension Pressure {
    enum MillimetersOfMercury: StaticUnit {
        public typealias Base = Pressure
    }
}

#if LocalizedSymbols
public extension Pressure.MillimetersOfMercury {
    static var symbol: UnitRepresentation {
        .init(symbol: .Pressure.millimetersOfMercurySymbol, name: SyntaxFunction {
            .Pressure.millimetersOfMercuryName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Pressure.MillimetersOfMercury, RawValue: Numeric & ExpressibleByFloatLiteral {
    var pressure: Tagged<Pressure, RawValue> { .init(rawValue * 133.322) }
}

public extension Tagged where Tag == Pressure, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var millimetersOfMercury: Tagged<Pressure.MillimetersOfMercury, RawValue> { .init(rawValue / 133.322) }
}

// MARK: Self.PoundsForcePerSquareInch
public extension Pressure {
    enum PoundsForcePerSquareInch: StaticUnit {
        public typealias Base = Pressure
    }
}

#if LocalizedSymbols
public extension Pressure.PoundsForcePerSquareInch {
    static var symbol: UnitRepresentation {
        .init(symbol: .Pressure.poundsForcePerSquareInchSymbol, name: SyntaxFunction {
            .Pressure.poundsForcePerSquareInchName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Pressure.PoundsForcePerSquareInch, RawValue: Numeric & ExpressibleByFloatLiteral {
    var pressure: Tagged<Pressure, RawValue> { .init(rawValue * 6894.76) }
}

public extension Tagged where Tag == Pressure, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var poundsForcePerSquareInch: Tagged<Pressure.PoundsForcePerSquareInch, RawValue> { .init(rawValue / 6894.76) }
}
