//
//  Duration.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import TrinketsUnits

public enum Time: Dimension {
    public typealias BaseUnit = Self.Seconds
}

// MARK: Self.Seconds
public extension Time {
    enum Seconds: StaticUnit {
        public typealias Base = Time
    }
}

public extension StaticConverter where Origin == Time.Seconds, Target == Time, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Time, Target == Time.Seconds, Value: Numeric {
    static var degrees: Self { .init { $0 } }
}

// MARK: Self.Minutes
public extension Time {
    enum Minutes: StaticUnit {
        public typealias Base = Time
    }
}

public extension StaticConverter where Origin == Time.Minutes, Target == Time, Value: Numeric {
    static var to: Self { .init { $0 * 60 } }
}

public extension StaticConverter where Origin == Time, Target == Time.Minutes, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var minutes: Self { .init { $0 / 60 } }
}

// MARK: Self.Hours
public extension Time {
    enum Hours: StaticUnit {
        public typealias Base = Time
    }
}

public extension StaticConverter where Origin == Time.Hours, Target == Time, Value: Numeric {
    static var to: Self { .init { $0 * 3600 } }
}

public extension StaticConverter where Origin == Time, Target == Time.Hours, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var hours: Self { .init { $0 / 3600 } }
}

// MARK: Self.Days
public extension Time {
    enum Days: StaticUnit {
        public typealias Base = Time
    }
}

public extension StaticConverter where Origin == Time.Days, Target == Time, Value: Numeric {
    static var to: Self { .init { $0 * 86400 } }
}

public extension StaticConverter where Origin == Time, Target == Time.Days, Value: FloatingPoint & ExpressibleByIntegerLiteral {
    static var days: Self { .init { $0 / 86400 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Time, RawValue == Time.Seconds.Type {
    static var seconds: Self { .init(Time.Seconds.self) }
}

public extension Tagged where Tag == Time, RawValue == Time.Minutes.Type {
    static var minutes: Self { .init(Time.Minutes.self) }
}

public extension Tagged where Tag == Time, RawValue == Time.Hours.Type {
    static var hours: Self { .init(Time.Hours.self) }
}

public extension Tagged where Tag == Time, RawValue == Time.Days.Type {
    static var days: Self { .init(Time.Days.self) }
}

public extension Tagged where Tag == Time, RawValue == Double {
    init(_ duration: Duration) {
        let v = duration.components
        let fractional = Double(v.attoseconds) * 10e-19
        let durationAsDouble = Double(v.seconds) + fractional
        self.init(durationAsDouble)
    }

    var asDuration: Duration { .seconds(rawValue) }
}
