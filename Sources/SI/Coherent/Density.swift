//
//  Density.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import TrinketsUnits

public enum Density: Dimension {
    public typealias BaseUnit = KilogramsPerCubicMeter

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: -3]
}

// MARK: Self.KilogramsPerCubicMeter
public extension Density {
    enum KilogramsPerCubicMeter: StaticUnit {
        public typealias Base = Density
    }
}

#if LocalizedSymbols
public extension Density.KilogramsPerCubicMeter {
    static var symbol: UnitRepresentation {
        .init(symbol: .Density.kilogramsPerCubicMeterSymbol, name: SyntaxFunction {
            .Density.kilogramsPerCubicMeterName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Density.KilogramsPerCubicMeter, Target == Density, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Density, Target == Density.KilogramsPerCubicMeter, Value: Numeric {
    static var kilogramsPerCubicMeter: Self { .init { $0 } }
}

// MARK: Self.GramsPerLiter
public extension Density {
    typealias GramsPerLiter = Fraction<Mass.Grams, Volume.Liters>
}

#if LocalizedSymbols
public extension Density.GramsPerLiter {
    static var symbol: UnitRepresentation {
        .init(symbol: .Density.gramsPerLiterSymbol, name: SyntaxFunction {
            .Density.gramsPerLiterName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Density.GramsPerLiter, Target == Density, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Density, Target == Density.GramsPerLiter, Value: Numeric {
    static var gramsPerLiter: Self { .init { $0 } }
}

// MARK: Self.MilligramsPerDeciliter
public extension Density {
    typealias MilligramsPerDeciliter = Fraction<PrefixedUnit<Milli, Mass.Grams>, PrefixedUnit<Deci, Volume.Liters>>
}

#if LocalizedSymbols
public extension Density.MilligramsPerDeciliter {
    static var symbol: UnitRepresentation {
        .init(symbol: .Density.milligramsPerDeciliterSymbol, name: SyntaxFunction {
            .Density.milligramsPerDeciliterName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Density.MilligramsPerDeciliter, Target == Density, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.01 } }
}

public extension StaticConverter where Origin == Density, Target == Density.MilligramsPerDeciliter, Value: Numeric {
    static var milligramsPerDeciliter: Self { .init { $0 * 100 } }
}

// MARK: Self.MillimolesPerLiter
public extension Density {
    struct MillimolesPerLiter: Convertible {
        public typealias Base = Density

        var gramsPerMole: Double

        public init(withGramsPerMole gramsPerMole: Double) {
            self.gramsPerMole = gramsPerMole
        }
    }
}

public extension Density.MillimolesPerLiter {
    func density<Value: Numeric & ExpressibleByFloatLiteral>(
        in _: Value.Type = Value.self
    ) -> Tagged<Density, Value> where Value.FloatLiteralType == Double {
        .init(Value(floatLiteral: 18 * gramsPerMole))
    }
}

#if LocalizedSymbols
public extension Density.MillimolesPerLiter {
    static var symbol: UnitRepresentation {
        .init(symbol: .Density.kilogramsPerCubicMeterSymbol, name: SyntaxFunction {
            .Density.kilogramsPerCubicMeterName(amount: $0)
        })
    }
}
#endif

public extension Measurement where UnitType == Density.MillimolesPerLiter, Value: FloatingPoint & ExpressibleByFloatLiteral, Value.FloatLiteralType == Double {
    var baseValue: Tagged<Density, Value> { unit.density() * .init(value) }
}

public extension Tagged where Tag == Density, RawValue: FloatingPoint & ExpressibleByFloatLiteral, RawValue.FloatLiteralType == Double {
    func millimolesPerLiter(withGramsPerMole gramsPerMole: Double) -> Measurement<Density.MillimolesPerLiter, RawValue> {
        let unit = Density.MillimolesPerLiter(withGramsPerMole: gramsPerMole)
        let value = (self / unit.density()).rawValue
        return Measurement(value, unit)
    }
}

// MARK: Mass (EX)
public extension Mass {
    typealias Concentration = Density
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Density, RawValue == Density.KilogramsPerCubicMeter.Type {
    static var kilogramsPerCubicMeter: Self { .init(Density.KilogramsPerCubicMeter.self) }
}

public extension Tagged where Tag == Density, RawValue == Density.GramsPerLiter.Type {
    static var gramsPerLiter: Self { .init(Density.GramsPerLiter.self) }
}

public extension Tagged where Tag == Density, RawValue == Density.MilligramsPerDeciliter.Type {
    static var milligramsPerDeciliter: Self { .init(Density.MilligramsPerDeciliter.self) }
}

public extension Tagged where Tag == Fraction<Mass, Volume> {
    var asDensity: Tagged<Density, RawValue> { .init(rawValue) }
}
