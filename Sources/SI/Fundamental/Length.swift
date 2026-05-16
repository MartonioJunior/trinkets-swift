//
//  Length.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import TrinketsUnits

public enum Length: Dimension {
    public typealias BaseUnit = Meters
}

// MARK: Self.Meters
public extension Length {
    enum Meters: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Meters, Target == Length, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Meters, Value: Numeric {
    static var meters: Self { .init { $0 } }
}

// MARK: Self.AstronomicalUnits
public extension Length {
    enum AstronomicalUnits: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.AstronomicalUnits, Target == Length, Value: Numeric {
    static var to: Self { .init { $0 * 149_597_870_700 } }
}

public extension StaticConverter where Origin == Length, Target == Length.AstronomicalUnits, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var astronomicalUnits: Self { .init { $0 / 149_597_870_700 } }
}

// MARK: Self.Inches
public extension Length {
    enum Inches: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Inches, Target == Length, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0254 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Inches, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var inches: Self { .init { $0 / 0.0254 } }
}

// MARK: Self.Feet
public extension Length {
    enum Feet: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Feet, Target == Length, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.3048 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Feet, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var feet: Self { .init { $0 / 0.3048 } }
}

// MARK: Self.Yards
public extension Length {
    enum Yards: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Yards, Target == Length, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.9144 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Yards, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var yards: Self { .init { $0 / 0.9144 } }
}

// MARK: Self.Miles
public extension Length {
    enum Miles: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Miles, Target == Length, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 1609.344 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Miles, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var miles: Self { .init { $0 / 1609.344 } }
}

// MARK: Self.ScandinavianMiles
public extension Length {
    enum ScandinavianMiles: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.ScandinavianMiles, Target == Length, Value: Numeric {
    static var to: Self { .init { $0 * 10000 } }
}

public extension StaticConverter where Origin == Length, Target == Length.ScandinavianMiles, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var scandinavianMiles: Self { .init { $0 / 10000 } }
}

// MARK: Self.LightYears
public extension Length {
    enum LightYears: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.LightYears, Target == Length, Value: Numeric {
    static var to: Self { .init { $0 * 9_460_730_472_580_800 } }
}

public extension StaticConverter where Origin == Length, Target == Length.LightYears, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var lightYears: Self { .init { $0 / 9_460_730_472_580_800 } }
}

// MARK: Self.NauticalMiles
public extension Length {
    enum NauticalMiles: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.NauticalMiles, Target == Length, Value: Numeric {
    static var to: Self { .init { $0 * 1852 } }
}

public extension StaticConverter where Origin == Length, Target == Length.NauticalMiles, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var nauticalMiles: Self { .init { $0 / 1852 } }
}

// MARK: Self.Fathoms
public extension Length {
    enum Fathoms: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Fathoms, Target == Length, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 1.8288 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Fathoms, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var fathoms: Self { .init { $0 / 1.8288 } }
}

// MARK: Self.Furlongs
public extension Length {
    enum Furlongs: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Furlongs, Target == Length, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 201.168 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Furlongs, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var furlongs: Self { .init { $0 / 201.168 } }
}

// MARK: Self.Parsecs
public extension Length {
    enum Parsecs: StaticUnit {
        public typealias Base = Length
    }
}

public extension StaticConverter where Origin == Length.Parsecs, Target == Length, Value: Numeric {
    static var to: Self { .init { $0 * 3_085_677_581_410_000 } }
}

public extension StaticConverter where Origin == Length, Target == Length.Parsecs, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var parsecs: Self { .init { $0 / 3_085_677_581_410_000 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Length, RawValue == Length.Meters.Type {
    static var meters: Self { .init(Length.Meters.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.AstronomicalUnits.Type {
    static var astronomicalUnits: Self { .init(Length.AstronomicalUnits.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Inches.Type {
    static var inches: Self { .init(Length.Inches.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Feet.Type {
    static var feet: Self { .init(Length.Feet.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Yards.Type {
    static var yards: Self { .init(Length.Yards.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Miles.Type {
    static var miles: Self { .init(Length.Miles.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.ScandinavianMiles.Type {
    static var scandinavianMiles: Self { .init(Length.ScandinavianMiles.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.LightYears.Type {
    static var lightYears: Self { .init(Length.LightYears.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.NauticalMiles.Type {
    static var nauticalMiles: Self { .init(Length.NauticalMiles.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Fathoms.Type {
    static var fathoms: Self { .init(Length.Fathoms.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Furlongs.Type {
    static var furlongs: Self { .init(Length.Furlongs.self) }
}

public extension Tagged where Tag == Length, RawValue == Length.Parsecs.Type {
    static var parsecs: Self { .init(Length.Parsecs.self) }
}
