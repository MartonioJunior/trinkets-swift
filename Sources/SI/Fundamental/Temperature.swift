//
//  Temperature.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
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

#if LocalizedSymbols
public extension Temperature.Kelvin {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Temperature.kelvinSymbol, name: .Temperature.kelvinName)
    }
}
#endif

public extension Tagged where Tag == Temperature.Kelvin, RawValue: AdditiveArithmetic & ExpressibleByFloatLiteral {
    var temperature: Tagged<Temperature, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Temperature, RawValue: AdditiveArithmetic & ExpressibleByFloatLiteral {
    var kelvin: Tagged<Temperature.Kelvin, RawValue> {
        .init(rawValue)
    }
}

// MARK: Self.Celsius
public extension Temperature {
    enum Celsius: StaticUnit {
        public typealias Base = Temperature
    }
}

#if LocalizedSymbols
public extension Temperature.Celsius {
    static var symbol: UnitRepresentation {
        .init(symbol: .Temperature.celsiusSymbol, name: SyntaxFunction {
            .Temperature.celsiusName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Temperature.Celsius, RawValue: AdditiveArithmetic & ExpressibleByFloatLiteral {
    var temperature: Tagged<Temperature, RawValue> { .init(rawValue + 273.15) }
}

public extension Tagged where Tag == Temperature, RawValue: AdditiveArithmetic & ExpressibleByFloatLiteral {
    var celsius: Tagged<Temperature.Celsius, RawValue> {
        .init(rawValue - 273.15)
    }
}

// MARK: Self.Fahrenheit
public extension Temperature {
    enum Fahrenheit: StaticUnit {
        public typealias Base = Temperature
    }
}

#if LocalizedSymbols
public extension Temperature.Fahrenheit {
    static var symbol: UnitRepresentation {
        .init(symbol: .Temperature.fahrenheitSymbol, name: SyntaxFunction {
            .Temperature.fahrenheitName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Temperature.Fahrenheit, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var temperature: Tagged<Temperature, RawValue> { .init((rawValue + 459.67) * 5 / 9) }
}

public extension Tagged where Tag == Temperature, RawValue: Numeric & ExpressibleByFloatLiteral {
    var fahrenheit: Tagged<Temperature.Fahrenheit, RawValue> {
        .init((rawValue * 1.8) - 459.67)
    }
}
