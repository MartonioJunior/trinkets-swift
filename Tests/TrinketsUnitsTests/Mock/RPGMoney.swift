//
//  GilDimension.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/06/25.
//

import Tagged
import TrinketsUnits

public struct RPGMoney {}

// MARK: Self: Dimension
extension RPGMoney: Dimension {
    public typealias BaseUnit = Gil
}

// MARK: Self.Gil
public extension RPGMoney {
    enum Gil: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "g" }
    }
}

extension RPGMoney.Gil: Sendable {}

public extension Tagged where Tag == RPGMoney.Gil, RawValue: Numeric {
    var rpgMoney: Tagged<RPGMoney, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == RPGMoney, RawValue: Numeric {
    var gil: Tagged<RPGMoney.Gil, RawValue> { .init(rawValue) }
}

// MARK: Self.Linen
public extension RPGMoney {
    enum Linen: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "ln" }
    }
}

extension RPGMoney.Linen: Sendable {}

public extension Tagged where Tag == RPGMoney.Linen, RawValue: Numeric {
    var rpgMoney: Tagged<RPGMoney, RawValue> { .init(rawValue * 2 + 7) }
}

public extension Tagged where Tag == RPGMoney, RawValue: FloatingPoint {
    var linen: Tagged<RPGMoney.Linen, RawValue> { .init((rawValue - 7) / 2) }
}

// MARK: Self.Zeni
public extension RPGMoney {
    enum Zeni: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "z" }
    }
}

extension RPGMoney.Zeni: Sendable {}

public extension Tagged where Tag == RPGMoney.Zeni, RawValue: Numeric {
    var rpgMoney: Tagged<RPGMoney, RawValue> { .init(rawValue * 3) }
}

public extension Tagged where Tag == RPGMoney, RawValue: FloatingPoint {
    var zeni: Tagged<RPGMoney.Zeni, RawValue> { .init(rawValue / 3) }
}

// MARK: Self.Zero
public extension RPGMoney {
    enum Zero: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "0" }
    }
}

extension RPGMoney.Zero: Sendable {}

public extension Tagged where Tag == RPGMoney.Zero, RawValue: Numeric {
    var rpgMoney: Tagged<RPGMoney, RawValue> { .init(.zero) }
}

public extension Tagged where Tag == RPGMoney, RawValue: Numeric {
    var zero: Tagged<RPGMoney.Zero, RawValue> { .init(.zero) }
}

// MARK: Self.Constant
public extension RPGMoney {
    struct Constant: Convertible {
        public typealias Base = RPGMoney

        var value: Int

        static var symbol: String { "k!" }

        public init(value: Int) {
            self.value = value
        }
    }
}

extension RPGMoney.Constant: CustomStringConvertible {
    public var description: String { "\(value)$" }
}

extension RPGMoney.Constant: Formattable {}

extension RPGMoney.Constant: Equatable, Sendable {}

public extension DynamicConverter where Unit == RPGMoney.Constant, Reference == RPGMoney, Value: AdditiveArithmetic & ExpressibleByIntegerLiteral, Value.IntegerLiteralType == Int {
    static var base: Self { .init { Value(integerLiteral: $0.value) + $1 } }
    static var converter: Self { .init { $1 - Value(integerLiteral: $0.value) } }
}

public extension Measurement where UnitType == RPGMoney.Constant, Value: AdditiveArithmetic & ExpressibleByIntegerLiteral, Value.IntegerLiteralType == Int {
    var baseValue: Tagged<RPGMoney, Value> { baseValue(.base) }
}

// MARK: Tagged (EX)
public extension Tagged where Tag == RPGMoney, RawValue: FloatingPoint {
    func constant(_ value: Int) -> Measurement<RPGMoney.Constant, RawValue> {
        .init(rawValue, .init(value: value))
    }
}
