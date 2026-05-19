//
//  Pressure.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import TrinketsUnits

public typealias Stress = Pressure

public enum Pressure: Dimension {
    public typealias BaseUnit = Pascals

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: -1, Time.self: -2]
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

public extension StaticConverter where Origin == Pressure.Pascals, Target == Pressure, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Pressure, Target == Pressure.Pascals, Value: Numeric {
    static var pascals: Self { .init { $0 } }
}

// MARK: Self.NewtonsPerMetersSquared
public extension Pressure {
    typealias NewtonsPerMetersSquared = Fraction<Force.Newtons, Area.SquareMeters>
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

public extension StaticConverter where Origin == Pressure.NewtonsPerMetersSquared, Target == Pressure, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Pressure, Target == Pressure.NewtonsPerMetersSquared, Value: Numeric {
    static var newtonsPerMetersSquared: Self { .init { $0 } }
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

public extension StaticConverter where Origin == Pressure.Bars, Target == Pressure, Value: Numeric {
    static var to: Self { .init { $0 * 100_000 } }
}

public extension StaticConverter where Origin == Pressure, Target == Pressure.Bars, Value: FloatingPoint {
    static var bars: Self { .init { $0 / 100_000 } }
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

public extension StaticConverter where Origin == Pressure.InchesOfMercury, Target == Pressure, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 3386.39 } }
}

public extension StaticConverter where Origin == Pressure, Target == Pressure.InchesOfMercury, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var inchesOfMercury: Self { .init { $0 / 3386.39 } }
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

public extension StaticConverter where Origin == Pressure.MillimetersOfMercury, Target == Pressure, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 133.322 } }
}

public extension StaticConverter where Origin == Pressure, Target == Pressure.MillimetersOfMercury, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var millimetersOfMercury: Self { .init { $0 / 133.322 } }
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

public extension StaticConverter where Origin == Pressure.PoundsForcePerSquareInch, Target == Pressure, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 6894.76 } }
}

public extension StaticConverter where Origin == Pressure, Target == Pressure.PoundsForcePerSquareInch, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var poundsForcePerSquareInch: Self { .init { $0 / 6894.76 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Pressure, RawValue == Pressure.Pascals.Type {
    static var pascals: Self { .init(Pressure.Pascals.self) }
}

public extension Tagged where Tag == Pressure, RawValue == Pressure.NewtonsPerMetersSquared.Type {
    static var newtonsPerMetersSquared: Self { .init(Pressure.NewtonsPerMetersSquared.self) }
}

public extension Tagged where Tag == Pressure, RawValue == Pressure.Bars.Type {
    static var bars: Self { .init(Pressure.Bars.self) }
}

public extension Tagged where Tag == Pressure, RawValue == Pressure.InchesOfMercury.Type {
    static var inchesOfMercury: Self { .init(Pressure.InchesOfMercury.self) }
}

public extension Tagged where Tag == Pressure, RawValue == Pressure.MillimetersOfMercury.Type {
    static var millimetersOfMercury: Self { .init(Pressure.MillimetersOfMercury.self) }
}

public extension Tagged where Tag == Pressure, RawValue == Pressure.PoundsForcePerSquareInch.Type {
    static var poundsForcePerSquareInch: Self { .init(Pressure.PoundsForcePerSquareInch.self) }
}

public extension Tagged where Tag == Fraction<Force, Area> {
    var asPressure: Tagged<Pressure, RawValue> { .init(rawValue) }
}
