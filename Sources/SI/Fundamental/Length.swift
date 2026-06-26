//
//  Length.swift
//  JurassicRun
//
//  Created by Martônio Júnior on 09/02/25.
//

import Tagged
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

public extension Tagged where Tag == Length.Meters, RawValue: Numeric {
    var length: Tagged<Length, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Length, RawValue: Numeric {
    var meters: Tagged<Length.Meters, RawValue> { .init(rawValue) }
}

// MARK: Self.AstronomicalUnits
public extension Length {
    enum AstronomicalUnits: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.AstronomicalUnits, RawValue: Numeric {
    var length: Tagged<Length, RawValue> { .init(rawValue * 149_597_870_700) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var astronomicalUnits: Tagged<Length.AstronomicalUnits, RawValue> { .init(rawValue / 149_597_870_700) }
}

// MARK: Self.Inches
public extension Length {
    enum Inches: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Inches, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var length: Tagged<Length, RawValue> { .init(rawValue * 0.0254) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var inches: Tagged<Length.Inches, RawValue> { .init(rawValue / 0.0254) }
}

// MARK: Self.Feet
public extension Length {
    enum Feet: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Feet, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var length: Tagged<Length, RawValue> { .init(rawValue * 0.3048) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var feet: Tagged<Length.Feet, RawValue> { .init(rawValue / 0.3048) }
}

// MARK: Self.Yards
public extension Length {
    enum Yards: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Yards, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var length: Tagged<Length, RawValue> { .init(rawValue * 0.9144) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var yards: Tagged<Length.Yards, RawValue> { .init(rawValue / 0.9144) }
}

// MARK: Self.Miles
public extension Length {
    enum Miles: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Miles, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var length: Tagged<Length, RawValue> { .init(rawValue * 1609.344) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var miles: Tagged<Length.Miles, RawValue> { .init(rawValue / 1609.344) }
}

// MARK: Self.ScandinavianMiles
public extension Length {
    enum ScandinavianMiles: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.ScandinavianMiles, RawValue: Numeric {
    var length: Tagged<Length, RawValue> { .init(rawValue * 10000) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var scandinavianMiles: Tagged<Length.ScandinavianMiles, RawValue> { .init(rawValue / 10000) }
}

// MARK: Self.LightYears
public extension Length {
    enum LightYears: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.LightYears, RawValue: Numeric {
    var length: Tagged<Length, RawValue> { .init(rawValue * 9_460_730_472_580_800) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var lightYears: Tagged<Length.LightYears, RawValue> { .init(rawValue / 9_460_730_472_580_800) }
}

// MARK: Self.NauticalMiles
public extension Length {
    enum NauticalMiles: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.NauticalMiles, RawValue: Numeric {
    var length: Tagged<Length, RawValue> { .init(rawValue * 1852) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var nauticalMiles: Tagged<Length.NauticalMiles, RawValue> { .init(rawValue / 1852) }
}

// MARK: Self.Fathoms
public extension Length {
    enum Fathoms: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Fathoms, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var length: Tagged<Length, RawValue> { .init(rawValue * 1.8288) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var fathoms: Tagged<Length.Fathoms, RawValue> { .init(rawValue / 1.8288) }
}

// MARK: Self.Furlongs
public extension Length {
    enum Furlongs: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Furlongs, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var length: Tagged<Length, RawValue> { .init(rawValue * 201.168) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var furlongs: Tagged<Length.Furlongs, RawValue> { .init(rawValue / 201.168) }
}

// MARK: Self.Parsecs
public extension Length {
    enum Parsecs: StaticUnit {
        public typealias Base = Length
    }
}

public extension Tagged where Tag == Length.Parsecs, RawValue: Numeric {
    var length: Tagged<Length, RawValue> { .init(rawValue * 3_085_677_581_410_000) }
}

public extension Tagged where Tag == Length, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var parsecs: Tagged<Length.Parsecs, RawValue> { .init(rawValue / 3_085_677_581_410_000) }
}
