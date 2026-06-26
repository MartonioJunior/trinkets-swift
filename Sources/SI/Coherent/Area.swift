//
//  Area.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Notation
import Tagged
import TrinketsUnits

public enum Area: Dimension {
    public typealias BaseUnit = SquareMeters

    public static let dimensionality: Dimensionality = [Length.self: 2]
}

@available(macOS 26.0, *)
public extension Tagged where Tag == Exponential<Length, 2> {
    var asArea: Tagged<Area, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Fraction<Volume, Length> {
    var asArea: Tagged<Area, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Length, Length> {
    var asArea: Tagged<Area, RawValue> { .init(rawValue) }
}

@available(macOS 26.0, *)
public extension Tagged where Tag == Square<Length.Meters> {
    var asArea: Tagged<Area.SquareMeters, RawValue> { .init(rawValue) }
}

// MARK: Self.SquareMeters
public extension Area {
    enum SquareMeters: StaticUnit {
        public typealias Base = Area
    }
}

public extension Tagged where Tag == Area.SquareMeters, RawValue: Numeric {
    var area: Tagged<Area, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Area, RawValue: Numeric {
    var squareMeters: Tagged<Area.SquareMeters, RawValue> { .init(rawValue) }
}

// MARK: Self.Acres
public extension Area {
    enum Acres: StaticUnit {
        public typealias Base = Area
    }
}

#if LocalizedSymbols
public extension Area.Acres {
    static var symbol: UnitRepresentation {
        .init(symbol: .Area.acresSymbol, name: SyntaxFunction {
            .Area.acresName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Area.Acres, RawValue: Numeric & ExpressibleByFloatLiteral {
    var area: Tagged<Area, RawValue> { .init(rawValue * 4046.86) }
}

public extension Tagged where Tag == Area, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var acres: Tagged<Area.Acres, RawValue> { .init(rawValue / 4046.86) }
}

// MARK: Self.Ares
public extension Area {
    enum Ares: StaticUnit {
        public typealias Base = Area
    }
}

#if LocalizedSymbols
public extension Area.Ares {
    static var symbol: UnitRepresentation {
        .init(symbol: .Area.aresSymbol, name: SyntaxFunction {
            .Area.aresName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Area.Ares, RawValue: Numeric {
    var area: Tagged<Area, RawValue> { .init(rawValue * 100) }
}

public extension Tagged where Tag == Area, RawValue: FloatingPoint {
    var ares: Tagged<Area.Ares, RawValue> { .init(rawValue / 100) }
}

// MARK: Self.Hectares
public extension Area {
    typealias Hectares = PrefixedUnit<Hecto, Ares>
}

#if LocalizedSymbols
public extension Area.Hectares {
    // 10.000 m2
    static var symbol: UnitRepresentation {
        .init(symbol: .Area.hectaresSymbol, name: SyntaxFunction {
            .Area.hectaresName(amount: $0)
        })
    }
}
#endif
