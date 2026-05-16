//
//  Mass.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

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

public extension StaticConverter where Origin == Mass.Grams, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.001 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.Grams, Value: Numeric {
    static var grams: Self { .init { $0 * 1000 } }
}

// MARK: Self.MetricTons
public extension Mass {
    enum MetricTons: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.MetricTons, Target == Mass, Value: Numeric {
    static var to: Self { .init { $0 * 1000 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.MetricTons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var metricTons: Self { .init { $0 * 0.001 } }
}

// MARK: Self.Ounces
public extension Mass {
    enum Ounces: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.Ounces, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0283495 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.Ounces, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var ounces: Self { .init { $0 / 0.0283495 } }
}

// MARK: Self.Pounds
public extension Mass {
    enum Pounds: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.Pounds, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.453592 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.Pounds, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var pounds: Self { .init { $0 / 0.453592 } }
}

// MARK: Self.Stones
public extension Mass {
    enum Stones: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.Stones, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.157473 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.Stones, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var stones: Self { .init { $0 / 0.157473 } }
}

// MARK: Self.ShortTons
public extension Mass {
    enum ShortTons: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.ShortTons, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 907.185 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.ShortTons, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var shortTons: Self { .init { $0 / 907.185 } }
}

// MARK: Self.Carats
public extension Mass {
    enum Carats: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.Carats, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.0002 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.Carats, Value: Numeric {
    static var carats: Self { .init { $0 * 5000 } }
}

// MARK: Self.OuncesTroy
public extension Mass {
    enum OuncesTroy: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.OuncesTroy, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.03110348 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.OuncesTroy, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var ouncesTroy: Self { .init { $0 / 0.03110348 } }
}

// MARK: Self.Slugs
public extension Mass {
    enum Slugs: StaticUnit {
        public typealias Base = Mass
    }
}

public extension StaticConverter where Origin == Mass.Slugs, Target == Mass, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 14.5939 } }
}

public extension StaticConverter where Origin == Mass, Target == Mass.Slugs, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var slugs: Self { .init { $0 / 14.5939 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Mass, RawValue == Mass.Grams.Type {
    static var grams: Self { .init(Mass.Grams.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.MetricTons.Type {
    static var metricTons: Self { .init(Mass.MetricTons.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.Ounces.Type {
    static var ounces: Self { .init(Mass.Ounces.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.Pounds.Type {
    static var pounds: Self { .init(Mass.Pounds.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.Stones.Type {
    static var stones: Self { .init(Mass.Stones.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.ShortTons.Type {
    static var shortTons: Self { .init(Mass.ShortTons.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.Carats.Type {
    static var carats: Self { .init(Mass.Carats.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.OuncesTroy.Type {
    static var ouncesTroy: Self { .init(Mass.OuncesTroy.self) }
}

public extension Tagged where Tag == Mass, RawValue == Mass.Slugs.Type {
    static var slugs: Self { .init(Mass.Slugs.self) }
}
