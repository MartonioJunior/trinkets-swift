//
//  Area.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Notation
import TrinketsUnits

public enum Area: Dimension {
    public typealias BaseUnit = SquareMeters

    public static let dimensionality: Dimensionality = [Length.self: 2]
}

// MARK: Self.SquareMeters
public extension Area {
    enum SquareMeters: StaticUnit {
        public typealias Base = Area
    }
}

public extension StaticConverter where Origin == Area.SquareMeters, Target == Area, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Area, Target == Area.SquareMeters, Value: Numeric {
    static var squareMeters: Self { .init { $0 } }
}

// MARK: Self.Acres
public extension Area {
    enum Acres: StaticUnit {
        public typealias Base = Area
    }
}

public extension Area.Acres {
    static var symbol: UnitRepresentation {
        .init(symbol: .Area.acresSymbol, name: SyntaxFunction {
            .Area.acresName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Area.Acres, Target == Area, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 4046.86 } }
}

public extension StaticConverter where Origin == Area, Target == Area.Acres, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var acres: Self { .init { $0 / 4046.86 } }
}

// MARK: Self.Ares
public extension Area {
    enum Ares: StaticUnit {
        public typealias Base = Area
    }
}

public extension Area.Ares {
    static var symbol: UnitRepresentation {
        .init(symbol: .Area.aresSymbol, name: SyntaxFunction {
            .Area.aresName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Area.Ares, Target == Area, Value: Numeric {
    static var to: Self { .init { $0 * 100 } }
}

public extension StaticConverter where Origin == Area, Target == Area.Ares, Value: FloatingPoint {
    static var ares: Self { .init { $0 / 100 } }
}

// MARK: Self.Hectares
public extension Area {
    typealias Hectares = PrefixedUnit<Hecto, Ares>
}

public extension Area.Hectares {
    // 10.000 m2
    static var symbol: UnitRepresentation {
        .init(symbol: .Area.hectaresSymbol, name: SyntaxFunction {
            .Area.hectaresName(amount: $0)
        })
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Area, RawValue == Area.SquareMeters.Type {
    static var squareMeters: Self { .init(Area.SquareMeters.self) }
}

public extension Tagged where Tag == Area, RawValue == Area.Acres.Type {
    static var acres: Self { .init(Area.Acres.self) }
}

public extension Tagged where Tag == Area, RawValue == Area.Ares.Type {
    static var ares: Self { .init(Area.Ares.self) }
}

public extension Tagged where Tag == Area, RawValue == Area.Hectares.Type {
    static var hectares: Self { .init(Area.Hectares.self) }
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
