//
//  Volume.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum Volume: Dimension {
    public typealias BaseUnit = CubicMeters

    public static let dimensionality: Dimensionality = [Length.self: 3]
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

public extension Tagged where Tag == Volume.CubicMeters, RawValue: Numeric {
    var volume: Tagged<Volume, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Volume, RawValue: Numeric {
    var cubicMeters: Tagged<Volume.CubicMeters, RawValue> { .init(rawValue) }
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

public extension Tagged where Tag == Volume.Liters, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.001) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint {
    var liters: Tagged<Volume.Liters, RawValue> { .init(rawValue / 1000) }
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

public extension Tagged where Tag == Volume.AcreFeet, RawValue: Numeric {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 1_233) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint {
    var acreFeet: Tagged<Volume.AcreFeet, RawValue> { .init(rawValue / 1_233) }
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

public extension Tagged where Tag == Volume.Bushels, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.0352391) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var bushels: Tagged<Volume.Bushels, RawValue> { .init(rawValue / 0.0352391) }
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

public extension Tagged where Tag == Volume.TeaSpoons, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00000492892) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var teaSpoons: Tagged<Volume.TeaSpoons, RawValue> { .init(rawValue / 0.00000492892) }
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

public extension Tagged where Tag == Volume.TableSpoons, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.0000147868) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var tableSpoons: Tagged<Volume.TableSpoons, RawValue> { .init(rawValue / 0.0000147868) }
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

public extension Tagged where Tag == Volume.FluidOunces, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.0000295735) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var fluidOunces: Tagged<Volume.FluidOunces, RawValue> { .init(rawValue / 0.0000295735) }
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

public extension Tagged where Tag == Volume.Cups, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00024) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var cups: Tagged<Volume.Cups, RawValue> { .init(rawValue / 0.00024) }
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

public extension Tagged where Tag == Volume.Pints, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.000473176) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var pints: Tagged<Volume.Pints, RawValue> { .init(rawValue / 0.000473176) }
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

public extension Tagged where Tag == Volume.Quarts, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.000946353) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var quarts: Tagged<Volume.Quarts, RawValue> { .init(rawValue / 0.000946353) }
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

public extension Tagged where Tag == Volume.Gallons, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00378541) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var gallons: Tagged<Volume.Gallons, RawValue> { .init(rawValue / 0.00378541) }
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

public extension Tagged where Tag == Volume.ImperialTeaSpoons, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00000591939) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var imperialTeaSpoons: Tagged<Volume.ImperialTeaSpoons, RawValue> { .init(rawValue / 0.00000591939) }
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

public extension Tagged where Tag == Volume.ImperialTableSpoons, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.0000177582) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var imperialTableSpoons: Tagged<Volume.ImperialTableSpoons, RawValue> { .init(rawValue / 0.0000177582) }
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

public extension Tagged where Tag == Volume.ImperialFluidOunces, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.0000284131) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var imperialFluidOunces: Tagged<Volume.ImperialFluidOunces, RawValue> { .init(rawValue / 0.0000284131) }
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

public extension Tagged where Tag == Volume.ImperialPints, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.000568261) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var imperialPints: Tagged<Volume.ImperialPints, RawValue> { .init(rawValue / 0.000568261) }
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

public extension Tagged where Tag == Volume.ImperialQuarts, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00113652) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var imperialQuarts: Tagged<Volume.ImperialQuarts, RawValue> { .init(rawValue / 0.00113652) }
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

public extension Tagged where Tag == Volume.ImperialGallons, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00454609) }
}

public extension Tagged where Tag == Volume, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var imperialGallons: Tagged<Volume.ImperialGallons, RawValue> { .init(rawValue / 0.00454609) }
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

public extension Tagged where Tag == Volume.MetricCups, RawValue: Numeric & ExpressibleByFloatLiteral {
    var volume: Tagged<Volume, RawValue> { .init(rawValue * 0.00025) }
}

public extension Tagged where Tag == Volume, RawValue: Numeric {
    var metricCups: Tagged<Volume.MetricCups, RawValue> { .init(rawValue * 4000) }
}
