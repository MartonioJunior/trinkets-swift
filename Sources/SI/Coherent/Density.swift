//
//  Density.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum Density: Dimension {
    public typealias BaseUnit = KilogramsPerCubicMeter

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: -3]
}

public extension Tagged where Tag == FractionUnit<Mass, Volume> {
    var asDensity: Tagged<Density, RawValue> { .init(rawValue) }
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

public extension Tagged where Tag == Density.KilogramsPerCubicMeter, RawValue: Numeric {
    var density: Tagged<Density, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Density, RawValue: Numeric {
    var kilogramsPerCubicMeter: Tagged<Density.KilogramsPerCubicMeter, RawValue> { .init(rawValue) }
}

// MARK: Self.GramsPerLiter
public extension Density {
    typealias GramsPerLiter = FractionUnit<Mass.Grams, Volume.Liters>
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

public extension Tagged where Tag == Density.GramsPerLiter, RawValue: Numeric {
    var density: Tagged<Density, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Density, RawValue: Numeric {
    var gramsPerLiter: Tagged<Density.GramsPerLiter, RawValue> { .init(rawValue) }
}

// MARK: Self.MilligramsPerDeciliter
public extension Density {
    typealias MilligramsPerDeciliter = FractionUnit<PrefixedUnit<Milli, Mass.Grams>, PrefixedUnit<Deci, Volume.Liters>>
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

public extension Tagged where Tag == Density.MilligramsPerDeciliter, RawValue: Numeric & ExpressibleByFloatLiteral {
    var density: Tagged<Density, RawValue> { .init(rawValue * 0.01) }
}

public extension Tagged where Tag == Density, RawValue: Numeric {
    var milligramsPerDeciliter: Tagged<Density.MilligramsPerDeciliter, RawValue> { .init(rawValue * 100) }
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
    func density<RawValue: Numeric & ExpressibleByFloatLiteral>(
        in _: RawValue.Type = RawValue.self
    ) -> Tagged<Density, RawValue> where RawValue.FloatLiteralType == Double {
        .init(RawValue(floatLiteral: 18 * gramsPerMole))
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
    var baseRawValue: Tagged<Density, Value> { unit.density() * .init(value) }
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
