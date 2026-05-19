//
//  Volume.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import TrinketsUnits

public enum Volume: Dimension {
    public typealias BaseUnit = CubicMeters

    public static let dimensionality: Dimensionality = [Length.self: 3]
}

// MARK: Self.CubicMeters
public extension Volume {
    enum CubicMeters: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.CubicMeters {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.cubicMetersSymbol, name: SyntaxFunction {
            .Volume.cubicMetersName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.CubicMeters, Target == Volume, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.CubicMeters, Value: Numeric {
    static var cubicMeters: Self { .init { $0 } }
}

// MARK: Self.Liters
public extension Volume {
    enum Liters: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.Liters {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.litersSymbol, name: SyntaxFunction {
            .Volume.litersName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.Liters, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.001 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.Liters, Value: FloatingPoint {
    static var liters: Self { .init { $0 / 1000 } }
}

// MARK: Self.AcreFeet
public extension Volume {
    enum AcreFeet: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.AcreFeet {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Volume.acreFeetSymbol, name: .Volume.acreFeetName)
    }
}
#endif

public extension StaticConverter where Origin == Volume.AcreFeet, Target == Volume, Value: Numeric {
    static var to: Self { .init { $0 * 1_233 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.AcreFeet, Value: FloatingPoint {
    static var acreFeet: Self { .init { $0 / 1_233 } }
}

// MARK: Self.Bushels
public extension Volume {
    enum Bushels: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.Bushels {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.bushelsSymbol, name: SyntaxFunction {
            .Volume.bushelsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.Bushels, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0352391 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.Bushels, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var bushels: Self { .init { $0 / 0.0352391 } }
}

// MARK: Self.TeaSpoons
public extension Volume {
    enum TeaSpoons: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.TeaSpoons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.teaSpoonsSymbol, name: SyntaxFunction {
            .Volume.teaSpoonsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.TeaSpoons, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00000492892 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.TeaSpoons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var teaSpoons: Self { .init { $0 / 0.00000492892 } }
}

// MARK: Self.TableSpoons
public extension Volume {
    enum TableSpoons: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.TableSpoons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.tableSpoonsSymbol, name: SyntaxFunction {
            .Volume.tableSpoonsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.TableSpoons, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0000147868 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.TableSpoons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var tableSpoons: Self { .init { $0 / 0.0000147868 } }
}

// MARK: Self.FluidOunces
public extension Volume {
    enum FluidOunces: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.FluidOunces {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.fluidOuncesSymbol, name: SyntaxFunction {
            .Volume.fluidOuncesName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.FluidOunces, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0000295735 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.FluidOunces, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var fluidOunces: Self { .init { $0 / 0.0000295735 } }
}

// MARK: Self.Cups
public extension Volume {
    enum Cups: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.Cups {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.cupsSymbol, name: SyntaxFunction {
            .Volume.cupsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.Cups, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00024 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.Cups, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var cups: Self { .init { $0 / 0.00024 } }
}

// MARK: Self.Pints
public extension Volume {
    enum Pints: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.Pints {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.pintsSymbol, name: SyntaxFunction {
            .Volume.pintsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.Pints, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.000473176 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.Pints, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var pints: Self { .init { $0 / 0.000473176 } }
}

// MARK: Self.Quarts
public extension Volume {
    enum Quarts: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.Quarts {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.quartsSymbol, name: SyntaxFunction {
            .Volume.quartsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.Quarts, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.000946353 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.Quarts, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var quarts: Self { .init { $0 / 0.000946353 } }
}

// MARK: Self.Gallons
public extension Volume {
    enum Gallons: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.Gallons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.gallonsSymbol, name: SyntaxFunction {
            .Volume.gallonsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.Gallons, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00378541 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.Gallons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var gallons: Self { .init { $0 / 0.00378541 } }
}

// MARK: Self.ImperialTeaSpoons
public extension Volume {
    enum ImperialTeaSpoons: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.ImperialTeaSpoons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.imperialTeaSpoonsSymbol, name: SyntaxFunction {
            .Volume.imperialTeaSpoonsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.ImperialTeaSpoons, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00000591939 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.ImperialTeaSpoons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var imperialTeaSpoons: Self { .init { $0 / 0.00000591939 } }
}

// MARK: Self.ImperialTableSpoons
public extension Volume {
    enum ImperialTableSpoons: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.ImperialTableSpoons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.imperialTableSpoonsSymbol, name: SyntaxFunction {
            .Volume.imperialTableSpoonsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.ImperialTableSpoons, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0000177582 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.ImperialTableSpoons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var imperialTableSpoons: Self { .init { $0 / 0.0000177582 } }
}

// MARK: Self.ImperialFluidOunces
public extension Volume {
    enum ImperialFluidOunces: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.ImperialFluidOunces {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.imperialFluidOuncesSymbol, name: SyntaxFunction {
            .Volume.imperialFluidOuncesName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.ImperialFluidOunces, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0000284131 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.ImperialFluidOunces, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var imperialFluidOunces: Self { .init { $0 / 0.0000284131 } }
}

// MARK: Self.ImperialPints
public extension Volume {
    enum ImperialPints: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.ImperialPints {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.imperialPintsSymbol, name: SyntaxFunction {
            .Volume.imperialPintsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.ImperialPints, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.000568261 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.ImperialPints, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var imperialPints: Self { .init { $0 / 0.000568261 } }
}

// MARK: Self.ImperialQuarts
public extension Volume {
    enum ImperialQuarts: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.ImperialQuarts {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.imperialQuartsSymbol, name: SyntaxFunction {
            .Volume.imperialQuartsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.ImperialQuarts, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00113652 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.ImperialQuarts, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var imperialQuarts: Self { .init { $0 / 0.00113652 } }
}

// MARK: Self.ImperialGallons
public extension Volume {
    enum ImperialGallons: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.ImperialGallons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.imperialGallonsSymbol, name: SyntaxFunction {
            .Volume.imperialGallonsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.ImperialGallons, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00454609 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.ImperialGallons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var imperialGallons: Self { .init { $0 / 0.00454609 } }
}

// MARK: Self.MetricCups
public extension Volume {
    enum MetricCups: StaticUnit {
        public typealias Base = Volume
    }
}

#if LocalizedSymbols
public extension Volume.MetricCups {
    static var symbol: UnitRepresentation {
        .init(symbol: .Volume.metricCupsSymbol, name: SyntaxFunction {
            .Volume.metricCupsName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == Volume.MetricCups, Target == Volume, Value: Numeric & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00025 } }
}

public extension StaticConverter where Origin == Volume, Target == Volume.MetricCups, Value: Numeric {
    static var metricCups: Self { .init { $0 * 4000 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Volume, RawValue == Volume.CubicMeters.Type {
    static var cubicMeters: Self { .init(Volume.CubicMeters.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.Liters.Type {
    static var liters: Self { .init(Volume.Liters.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.AcreFeet.Type {
    static var acreFeet: Self { .init(Volume.AcreFeet.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.Bushels.Type {
    static var bushels: Self { .init(Volume.Bushels.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.TeaSpoons.Type {
    static var teaSpoons: Self { .init(Volume.TeaSpoons.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.TableSpoons.Type {
    static var tableSpoons: Self { .init(Volume.TableSpoons.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.FluidOunces.Type {
    static var fluidOunces: Self { .init(Volume.FluidOunces.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.Cups.Type {
    static var cups: Self { .init(Volume.Cups.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.Pints.Type {
    static var pints: Self { .init(Volume.Pints.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.Quarts.Type {
    static var quarts: Self { .init(Volume.Quarts.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.Gallons.Type {
    static var gallons: Self { .init(Volume.Gallons.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.ImperialTeaSpoons.Type {
    static var imperialTeaSpoons: Self { .init(Volume.ImperialTeaSpoons.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.ImperialTableSpoons.Type {
    static var imperialTableSpoons: Self { .init(Volume.ImperialTableSpoons.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.ImperialFluidOunces.Type {
    static var imperialFluidOunces: Self { .init(Volume.ImperialFluidOunces.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.ImperialPints.Type {
    static var imperialPints: Self { .init(Volume.ImperialPints.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.ImperialQuarts.Type {
    static var imperialQuarts: Self { .init(Volume.ImperialQuarts.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.ImperialGallons.Type {
    static var imperialGallons: Self { .init(Volume.ImperialGallons.self) }
}

public extension Tagged where Tag == Volume, RawValue == Volume.MetricCups.Type {
    static var metricCups: Self { .init(Volume.MetricCups.self) }
}

public extension Tagged where Tag == Product<Area, Length> {
    var asVolume: Tagged<Volume, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Length, Area> {
    var asVolume: Tagged<Volume, RawValue> { .init(rawValue) }
}

@available(macOS 26.0, *)
public extension Tagged where Tag == Exponential<Length, 3> {
    var asVolume: Tagged<Volume, RawValue> { .init(rawValue) }
}

@available(macOS 26.0, *)
public extension Tagged where Tag == Exponential<Length.Meters, 3> {
    var asVolume: Tagged<Volume.CubicMeters, RawValue> { .init(rawValue) }
}
