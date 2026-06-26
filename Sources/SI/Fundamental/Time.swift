//
//  Duration.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Tagged
import TrinketsUnits

public enum Time: Dimension {
    public typealias BaseUnit = Self.Seconds
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

// MARK: Self.Seconds
public extension Time {
    enum Seconds: StaticUnit {
        public typealias Base = Time
    }
}

public extension Tagged where Tag == Time.Seconds, RawValue: AdditiveArithmetic {
    var time: Tagged<Time, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Time, RawValue: AdditiveArithmetic {
    var seconds: Tagged<Time.Seconds, RawValue> { .init(rawValue) }
}

// MARK: Self.Minutes
public extension Time {
    enum Minutes: StaticUnit {
        public typealias Base = Time
    }
}

public extension Tagged where Tag == Time.Minutes, RawValue: Numeric {
    var time: Tagged<Time, RawValue> { .init(rawValue * 60) }
}

public extension Tagged where Tag == Time, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var minutes: Tagged<Time.Minutes, RawValue> { .init(rawValue / 60) }
}

// MARK: Self.Hours
public extension Time {
    enum Hours: StaticUnit {
        public typealias Base = Time
    }
}

public extension Tagged where Tag == Time.Hours, RawValue: Numeric {
    var time: Tagged<Time, RawValue> { .init(rawValue * 3600) }
}

public extension Tagged where Tag == Time, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var hours: Tagged<Time.Hours, RawValue> { .init(rawValue / 3600) }
}

// MARK: Self.Days
public extension Time {
    enum Days: StaticUnit {
        public typealias Base = Time
    }
}

public extension Tagged where Tag == Time.Days, RawValue: Numeric {
    var time: Tagged<Time, RawValue> { .init(rawValue * 86400) }
}

public extension Tagged where Tag == Time, RawValue: FloatingPoint & ExpressibleByIntegerLiteral {
    var days: Tagged<Time.Days, RawValue> { .init(rawValue / 86400) }
}
