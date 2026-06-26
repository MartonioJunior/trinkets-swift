//
//  Mass.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Tagged
import TrinketsUnits

public enum Mass: Dimension {
    public typealias BaseUnit = PrefixedUnit<Kilo, Grams>
}

// MARK: Self.Grams
public extension Mass {
    enum Grams: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.Grams, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 0.001) }
}

public extension Tagged where Tag == Mass, RawValue: Numeric {
    var grams: Tagged<Mass.Grams, RawValue> { .init(rawValue * 1000) }
}

// MARK: Self.MetricTons
public extension Mass {
    enum MetricTons: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.MetricTons, RawValue: Numeric {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 1000) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var metricTons: Tagged<Mass.MetricTons, RawValue> { .init(rawValue * 0.001) }
}

// MARK: Self.Ounces
public extension Mass {
    enum Ounces: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.Ounces, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 0.0283495) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var ounces: Tagged<Mass.Ounces, RawValue> { .init(rawValue / 0.0283495) }
}

// MARK: Self.Pounds
public extension Mass {
    enum Pounds: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.Pounds, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 0.453592) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var pounds: Tagged<Mass.Pounds, RawValue> { .init(rawValue / 0.453592) }
}

// MARK: Self.Stones
public extension Mass {
    enum Stones: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.Stones, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 0.157473) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var stones: Tagged<Mass.Stones, RawValue> { .init(rawValue / 0.157473) }
}

// MARK: Self.ShortTons
public extension Mass {
    enum ShortTons: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.ShortTons, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 907.185) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var shortTons: Tagged<Mass.ShortTons, RawValue> { .init(rawValue / 907.185) }
}

// MARK: Self.Carats
public extension Mass {
    enum Carats: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.Carats, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 0.0002) }
}

public extension Tagged where Tag == Mass, RawValue: Numeric {
    var carats: Tagged<Mass.Carats, RawValue> { .init(rawValue * 5000) }
}

// MARK: Self.OuncesTroy
public extension Mass {
    enum OuncesTroy: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.OuncesTroy, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 0.03110348) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var ouncesTroy: Tagged<Mass.OuncesTroy, RawValue> { .init(rawValue / 0.03110348) }
}

// MARK: Self.Slugs
public extension Mass {
    enum Slugs: StaticUnit {
        public typealias Base = Mass
    }
}

public extension Tagged where Tag == Mass.Slugs, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var mass: Tagged<Mass, RawValue> { .init(rawValue * 14.5939) }
}

public extension Tagged where Tag == Mass, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var slugs: Tagged<Mass.Slugs, RawValue> { .init(rawValue / 14.5939) }
}
