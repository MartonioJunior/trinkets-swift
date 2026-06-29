//
//  Energy.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
import TrinketsUnits

public typealias Work = Energy
public typealias HeatAmount = Energy

public enum Energy: Dimension {
    public typealias BaseUnit = Joules

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -2]
}

public extension Tagged where Tag == ProductUnit<Force, Length> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ProductUnit<Length, Force> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ProductUnit<Power, Time> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ProductUnit<Time, Power> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

// MARK: Self.Joules
public extension Energy {
    enum Joules: StaticUnit {
        public typealias Base = Energy
    }
}

#if LocalizedSymbols
public extension Energy.Joules {
    static var symbol: UnitRepresentation {
        .init(symbol: .Energy.joulesSymbol, name: SyntaxFunction {
            .Energy.joulesName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Energy.Joules, RawValue: Numeric {
    var energy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Energy, RawValue: Numeric {
    var joules: Tagged<Energy.Joules, RawValue> { .init(rawValue) }
}

// MARK: Self.Calories
public extension Energy {
    enum Calories: StaticUnit {
        public typealias Base = Energy
    }
}

#if LocalizedSymbols
public extension Energy.Calories {
    static var symbol: UnitRepresentation {
        .init(symbol: .Energy.caloriesSymbol, name: SyntaxFunction {
            .Energy.caloriesName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Energy.Calories, RawValue: Numeric & ExpressibleByFloatLiteral {
    var energy: Tagged<Energy, RawValue> { .init(rawValue * 4.184) }
}

public extension Tagged where Tag == Energy, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var calories: Tagged<Energy.Calories, RawValue> { .init(rawValue / 4.184) }
}

// MARK: Self.MilliwattHours
public extension Energy {
    typealias MilliwattHours = ProductUnit<PrefixedUnit<Milli, Power.Watts>, Time.Hours>
}

#if LocalizedSymbols
public extension Energy.MilliwattHours {
    static var symbol: UnitRepresentation {
        .init(symbol: .Energy.milliwattHoursSymbol, name: SyntaxFunction {
            .Energy.milliwattHoursName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Energy.MilliwattHours, RawValue: Numeric & ExpressibleByFloatLiteral {
    var energy: Tagged<Energy, RawValue> { .init(rawValue * 3.6) }
}

public extension Tagged where Tag == Energy, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var milliwattHours: Tagged<Energy.MilliwattHours, RawValue> { .init(rawValue / 3.6) }
}

// MARK: Self.KilowattHours
public extension Energy {
    typealias KilowattHours = ProductUnit<PrefixedUnit<Kilo, Power.Watts>, Time.Hours>
}

#if LocalizedSymbols
public extension Energy.KilowattHours {
    static var symbol: UnitRepresentation {
        .init(symbol: .Energy.kilowattHoursSymbol, name: SyntaxFunction {
            .Energy.kilowattHoursName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == Energy.KilowattHours, RawValue: Numeric {
    var energy: Tagged<Energy, RawValue> { .init(rawValue * 3_600_000) }
}

public extension Tagged where Tag == Energy, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var kilowattHours: Tagged<Energy.KilowattHours, RawValue> { .init(rawValue / 3_600_000) }
}
