//
//  Temperature.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import TrinketsUnits

public enum Temperature: Dimension {
    public typealias BaseUnit = Kelvin
}

// MARK: Self.Kelvin
public extension Temperature {
    enum Kelvin: StaticUnit {
        public typealias Base = Temperature
    }
}

public extension Temperature.Kelvin {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Temperature.kelvinSymbol, name: .Temperature.kelvinName)
    }
}

public extension StaticConverter where Origin == Temperature.Kelvin, Target == Temperature, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Temperature, Target == Temperature.Kelvin, Value: Numeric {
    static var kelvin: Self { .init { $0 } }
}

// MARK: Self.Celsius
public extension Temperature {
    enum Celsius: StaticUnit {
        public typealias Base = Temperature
    }
}

public extension Temperature.Celsius {
    static var symbol: UnitRepresentation {
        .init(symbol: .Temperature.celsiusSymbol, name: SyntaxFunction {
            .Temperature.celsiusName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Temperature.Celsius, Target == Temperature, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 + 273.15 } }
}

public extension StaticConverter where Origin == Temperature, Target == Temperature.Celsius, Value: Numeric & ExpressibleByFloatLiteral {
    static var celsius: Self { .init { $0 - 273.15 } }
}

// MARK: Self.Fahrenheit
public extension Temperature {
    enum Fahrenheit: StaticUnit {
        public typealias Base = Temperature
    }
}

public extension Temperature.Fahrenheit {
    static var symbol: UnitRepresentation {
        .init(symbol: .Temperature.fahrenheitSymbol, name: SyntaxFunction {
            .Temperature.fahrenheitName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == Temperature.Fahrenheit, Target == Temperature, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { ($0 + 459.67) * 5 / 9 } }
}

public extension StaticConverter where Origin == Temperature, Target == Temperature.Fahrenheit, Value: Numeric & ExpressibleByFloatLiteral {
    static var fahrenheit: Self { .init { ($0 * 1.8) - 459.67 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Temperature, RawValue == Temperature.Kelvin.Type {
    static var kelvin: Self { .init(Temperature.Kelvin.self) }
}

public extension Tagged where Tag == Temperature, RawValue == Temperature.Celsius.Type {
    static var celsius: Self { .init(Temperature.Celsius.self) }
}

public extension Tagged where Tag == Temperature, RawValue == Temperature.Fahrenheit.Type {
    static var fahrenheit: Self { .init(Temperature.Fahrenheit.self) }
}
