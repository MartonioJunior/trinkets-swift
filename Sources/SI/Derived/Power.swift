//
//  Power.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
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

public extension Power.Watts {
    static var symbol: UnitRepresentation {
        .init(symbol: .Power.wattsSymbol, name: SyntaxFunction {
            .Power.wattsName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Power.Watts, Target == Power, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Power, Target == Power.Watts, Value: Numeric {
    static var watts: Self { .init { $0 } }
}

// MARK: Self.Horsepower
public extension Power {
    enum Horsepower: StaticUnit {
        public typealias Base = Power
    }
}

public extension Power.Horsepower {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Power.horsepowerSymbol, name: .Power.horsepowerName)
    }
}

public extension StaticConverter where Origin == Power.Horsepower, Target == Power, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 745.7 } }
}

public extension StaticConverter where Origin == Power, Target == Power.Horsepower, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var horsepower: Self { .init { $0 / 745.7 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Power, RawValue == Power.Watts.Type {
    static var watts: Self { .init(Power.Watts.self) }
}

public extension Tagged where Tag == Power, RawValue == Power.Horsepower.Type {
    static var horsepower: Self { .init(Power.Horsepower.self) }
}
