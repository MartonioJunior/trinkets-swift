//
//  Power.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
import TrinketsUnits

public typealias RadiantFlux = Power

public enum Power: Dimension {
    public typealias BaseUnit = Watts

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -3]
}

// MARK: Self.Watts
public extension Power {
    enum Watts: StaticUnit {
        public typealias Base = Power
    }
}

#if LocalizedSymbols
public extension Power.Watts {
    static var symbol: UnitRepresentation {
        .init(symbol: .Power.wattsSymbol, name: SyntaxFunction {
            .Power.wattsName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Power.Watts, RawValue: Numeric {
    var power: Tagged<Power, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Power, RawValue: Numeric {
    var watts: Tagged<Power.Watts, RawValue> { .init(rawValue) }
}

// MARK: Self.Horsepower
public extension Power {
    enum Horsepower: StaticUnit {
        public typealias Base = Power
    }
}

#if LocalizedSymbols
public extension Power.Horsepower {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Power.horsepowerSymbol, name: .Power.horsepowerName)
    }
}
#endif

public extension Tagged where Tag == Power.Horsepower, RawValue: Numeric & ExpressibleByFloatLiteral {
    var power: Tagged<Power, RawValue> { .init(rawValue * 745.7) }
}

public extension Tagged where Tag == Power, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var horsepower: Tagged<Power.Horsepower, RawValue> { .init(rawValue / 745.7) }
}
