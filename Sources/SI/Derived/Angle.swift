//
//  Angle.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

import Tagged
import TrinketsUnits

public enum Angle: Dimension {
    public typealias BaseUnit = Self.Degrees

    public static let dimensionality: Dimensionality = .dimensionless
}

// MARK: Angle.Degrees
public extension Angle {
    enum Degrees: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.Degrees, RawValue: Numeric {
    var angle: Tagged<Angle, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Angle, RawValue: Numeric {
    var degrees: Tagged<Angle.Degrees, RawValue> { .init(rawValue) }
}

// MARK: Angle.ArcMinutes
public extension Angle {
    enum ArcMinutes: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.ArcMinutes, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var angle: Tagged<Angle, RawValue> { .init(rawValue * 0.016667) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var arcMinutes: Tagged<Angle.ArcMinutes, RawValue> { .init(rawValue / 0.016667) }
}

// MARK: Angle.ArcSeconds
public extension Angle {
    enum ArcSeconds: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.ArcSeconds, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var angle: Tagged<Angle, RawValue> { .init(rawValue * 0.00027778) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var arcSeconds: Tagged<Angle.ArcSeconds, RawValue> { .init(rawValue / 0.00027778) }
}

// MARK: Angle.Radians
public extension Angle {
    enum Radians: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.Radians, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var angle: Tagged<Angle, RawValue> { .init(rawValue * 57.29577951308232) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var radians: Tagged<Angle.Radians, RawValue> { .init(rawValue / 57.29577951308232) }
}

// MARK: Angle.Gradians
public extension Angle {
    enum Gradians: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.Gradians, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var angle: Tagged<Angle, RawValue> { .init(rawValue * 0.9) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var gradians: Tagged<Angle.Gradians, RawValue> { .init(rawValue / 0.9) }
}

// MARK: Angle.Revolutions
public extension Angle {
    enum Revolutions: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.Revolutions, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    var angle: Tagged<Angle, RawValue> { .init(rawValue * 360) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint {
    var revolutions: Tagged<Angle.Revolutions, RawValue> { .init(rawValue / 360) }
}

// MARK: Angle.Pi
public extension Angle {
    enum Pi: StaticUnit {
        public typealias Base = Angle
    }
}

public extension Tagged where Tag == Angle.Pi, RawValue: Numeric {
    var angle: Tagged<Angle, RawValue> { .init(rawValue * 180) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint {
    var pi: Tagged<Angle.Pi, RawValue> { .init(rawValue / 180) }
}

// MARK: Angle.SlicedCircle
public extension Angle {
    struct SlicedCircle: Convertible {
        public typealias Base = Angle

        var numberOfSlices: Int

        public init(in numberOfSlices: Int) {
            self.numberOfSlices = numberOfSlices
        }
    }
}

public extension Angle.SlicedCircle {
    func sliceAngle<Value: FloatingPoint & ExpressibleByFloatLiteral>(in _: Value.Type = Value.self) -> Tagged<Angle, Value> {
        .init(360.0 / Value(numberOfSlices))
    }
}

public extension Measurement where UnitType == Angle.SlicedCircle, Value: FloatingPoint & ExpressibleByFloatLiteral {
    var angle: Tagged<Angle, Value> { unit.sliceAngle() * .init(value) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    /// Represents the angle covered by a slice in a circle with equally divided slices
    func slicedCircle(of numberOfSlices: Int) -> Measurement<Angle.SlicedCircle, RawValue> {
        let unit = Angle.SlicedCircle(in: numberOfSlices)
        let value = (self / unit.sliceAngle()).rawValue
        return Measurement(value, unit)
    }
}

// MARK: Angle.Unit
public typealias AngleUnit = Tagged<Angle, UInt>

public extension AngleUnit {
    var baseValue: Tagged<Angle, Double> {
        let integerPart = Double(rawValue / 360)
        let fractionalPart = Double(rawValue % 360) / 360
        return .init(integerPart + fractionalPart)
    }
}
