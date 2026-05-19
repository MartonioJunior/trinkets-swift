//
//  Energy.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import TrinketsUnits

public typealias Work = Energy
public typealias HeatAmount = Energy

public enum Energy: Dimension {
    public typealias BaseUnit = Joules

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 2, Time.self: -2]
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

public extension StaticConverter where Origin == Energy.Joules, Target == Energy, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Energy, Target == Energy.Joules, Value: Numeric {
    static var joules: Self { .init { $0 } }
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

public extension StaticConverter where Origin == Energy.Calories, Target == Energy, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 4.184 } }
}

public extension StaticConverter where Origin == Energy, Target == Energy.Calories, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var calories: Self { .init { $0 / 4.184 } }
}

// MARK: Self.MilliwattHours
public extension Energy {
    typealias MilliwattHours = Product<PrefixedUnit<Milli, Power.Watts>, Time.Hours>
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

public extension StaticConverter where Origin == Energy.MilliwattHours, Target == Energy, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 3.6 } }
}

public extension StaticConverter where Origin == Energy, Target == Energy.MilliwattHours, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var milliwattHours: Self { .init { $0 / 3.6 } }
}

// MARK: Self.KilowattHours
public extension Energy {
    typealias KilowattHours = Product<PrefixedUnit<Kilo, Power.Watts>, Time.Hours>
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

public extension StaticConverter where Origin == Energy.KilowattHours, Target == Energy, Value: Numeric {
    static var to: Self { .init { $0 * 3_600_000 } }
}

public extension StaticConverter where Origin == Energy, Target == Energy.KilowattHours, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var kilowattHours: Self { .init { $0 / 3_600_000 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Energy, RawValue == Energy.Joules.Type {
    static var joules: Self { .init(Energy.Joules.self) }
}

public extension Tagged where Tag == Energy, RawValue == Energy.Calories.Type {
    static var calories: Self { .init(Energy.Calories.self) }
}

public extension Tagged where Tag == Energy, RawValue == Energy.MilliwattHours.Type {
    static var milliwattHours: Self { .init(Energy.MilliwattHours.self) }
}

public extension Tagged where Tag == Energy, RawValue == Energy.KilowattHours.Type {
    static var kilowattHours: Self { .init(Energy.KilowattHours.self) }
}

public extension Tagged where Tag == Product<Force, Length> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Length, Force> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Power, Time> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Time, Power> {
    var asEnergy: Tagged<Energy, RawValue> { .init(rawValue) }
}
