//
//  Frequency.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Tagged
import TrinketsUnits

public enum Frequency: Dimension {
    public typealias BaseUnit = Hertz

    public static let dimensionality: Dimensionality = [Time.self: -1]
}

@available(macOS 26.0, *)
public extension Tagged where Tag == Exponential<Time, -1> {
    var asFrequency: Tagged<Frequency, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Time, RawValue: FloatingPoint {
    var frequency: Tagged<Frequency, RawValue> { .init(1 / rawValue) }
}

public extension Tagged where Tag == Frequency, RawValue: FloatingPoint {
    var time: Tagged<Time, RawValue> { .init(1 / rawValue) }
}

// MARK: Self.Hertz
public extension Frequency {
    enum Hertz: StaticUnit {
        public typealias Base = Frequency
    }
}

#if LocalizedSymbols
public extension Frequency.Hertz {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .Frequency.hertzSymbol, name: .Frequency.hertzName)
    }
}
#endif

public extension Tagged where Tag == Frequency.Hertz, RawValue: Numeric {
    var frequency: Tagged<Frequency, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Frequency, RawValue: Numeric {
    var hertz: Tagged<Frequency.Hertz, RawValue> { .init(rawValue) }
}

// MARK: Self.Frames
public extension Frequency {
    struct Frames: Convertible {
        public typealias Base = Frequency

        var refreshRate: Tagged<Hertz, Int>

        public init(refreshRate: Tagged<Hertz, Int>) {
            self.refreshRate = refreshRate
        }
    }
}

public extension Frequency.Frames {
    static var cinema: Self { .init(refreshRate: 24) }
}

public extension Measurement where UnitType == Frequency.Frames, Value: FloatingPoint & ExpressibleByFloatLiteral {
    var baseValue: Tagged<Frequency, Value> { .init(Value(unit.refreshRate.rawValue) / value) }
}

public extension Tagged where Tag == Frequency, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    func frames(refreshRate: Tagged<Frequency.Hertz, Int>) -> Measurement<Frequency.Frames, RawValue> {
        .init(rawValue, .init(refreshRate: refreshRate))
    }
}

public extension Tagged where Tag == Time, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    func frames(refreshRate: Tagged<Frequency.Hertz, Int>) -> Measurement<Frequency.Frames, RawValue> {
        .init(rawValue * RawValue(refreshRate.rawValue), .init(refreshRate: refreshRate))
    }
}
