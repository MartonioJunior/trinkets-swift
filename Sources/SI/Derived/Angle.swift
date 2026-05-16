//
//  Angle.swift
//  Trinkets
//
//  Created by Martônio Júnior on 17/06/2025.
//

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

public extension StaticConverter where Origin == Angle.Degrees, Target == Angle, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.Degrees, Value: Numeric {
    static var degrees: Self { .init { $0 } }
}

// MARK: Angle.ArcMinutes
public extension Angle {
    enum ArcMinutes: StaticUnit {
        public typealias Base = Angle
    }
}

public extension StaticConverter where Origin == Angle.ArcMinutes, Target == Angle, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.016667 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.ArcMinutes, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var arcMinutes: Self { .init { $0 / 0.016667 } }
}

// MARK: Angle.ArcSeconds
public extension Angle {
    enum ArcSeconds: StaticUnit {
        public typealias Base = Angle
    }
}

public extension StaticConverter where Origin == Angle.ArcSeconds, Target == Angle, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.00027778 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.ArcSeconds, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var arcSeconds: Self { .init { $0 / 0.00027778 } }
}

// MARK: Angle.Radians
public extension Angle {
    enum Radians: StaticUnit {
        public typealias Base = Angle
    }
}

public extension StaticConverter where Origin == Angle.Radians, Target == Angle, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 57.29577951308232 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.Radians, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var radians: Self { .init { $0 / 57.29577951308232 } }
}

// MARK: Angle.Gradians
public extension Angle {
    enum Gradians: StaticUnit {
        public typealias Base = Angle
    }
}

public extension StaticConverter where Origin == Angle.Gradians, Target == Angle, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 0.9 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.Gradians, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var gradians: Self { .init { $0 / 0.9} }
}

// MARK: Angle.Revolutions
public extension Angle {
    enum Revolutions: StaticUnit {
        public typealias Base = Angle
    }
}

public extension StaticConverter where Origin == Angle.Revolutions, Target == Angle, Value: FloatingPoint & ExpressibleByFloatLiteral {
    static var to: Self { .init { $0 * 360 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.Revolutions, Value: FloatingPoint {
    static var revolutions: Self { .init { $0 / 360 } }
}

// MARK: Angle.Pi
public extension Angle {
    enum Pi: StaticUnit {
        public typealias Base = Angle
    }
}

public extension StaticConverter where Origin == Angle.Pi, Target == Angle, Value: Numeric {
    static var to: Self { .init { $0 * 180 } }
}

public extension StaticConverter where Origin == Angle, Target == Angle.Pi, Value: FloatingPoint {
    static var pi: Self { .init { $0 / 180 } }
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
    var baseValue: Tagged<Angle, Value> { unit.sliceAngle() * .init(value) }
}

public extension Tagged where Tag == Angle, RawValue: FloatingPoint & ExpressibleByFloatLiteral {
    /// Represents the angle covered by a slice in a circle with equally divided slices
    func slicedCircle(of numberOfSlices: Int) -> Measurement<Angle.SlicedCircle, RawValue> {
        let unit = Angle.SlicedCircle(in: numberOfSlices)
        let value = (self / unit.sliceAngle()).rawValue
        return Measurement(value, unit)
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Angle, RawValue == Angle.Degrees.Type {
    static var degrees: Self { .init(Angle.Degrees.self) }
}

public extension Tagged where Tag == Angle, RawValue == Angle.ArcMinutes.Type {
    static var arcMinutes: Self { .init(Angle.ArcMinutes.self) }
}

public extension Tagged where Tag == Angle, RawValue == Angle.ArcSeconds.Type {
    static var arcSeconds: Self { .init(Angle.ArcSeconds.self) }
}

public extension Tagged where Tag == Angle, RawValue == Angle.Radians.Type {
    static var radians: Self { .init(Angle.Radians.self) }
}

public extension Tagged where Tag == Angle, RawValue == Angle.Gradians.Type {
    static var gradians: Self { .init(Angle.Gradians.self) }
}

public extension Tagged where Tag == Angle, RawValue == Angle.Revolutions.Type {
    static var revolutions: Self { .init(Angle.Revolutions.self) }
}

public extension Tagged where Tag == Angle, RawValue == Angle.Pi.Type {
    static var pi: Self { .init(Angle.Pi.self) }
}
