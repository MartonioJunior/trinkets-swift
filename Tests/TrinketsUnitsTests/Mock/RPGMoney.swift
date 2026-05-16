//
//  GilDimension.swift
//  Trinkets
//
//  Created by Martônio Júnior on 16/06/25.
//

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

public extension StaticConverter where Origin == RPGMoney.Gil, Target == RPGMoney, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == RPGMoney, Target == RPGMoney.Gil, Value: Numeric {
    static var gil: Self { .init { $0 } }
}

// MARK: Self.Linen
public extension RPGMoney {
    enum Linen: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "ln" }
    }
}

extension RPGMoney.Linen: Sendable {}

public extension StaticConverter where Origin == RPGMoney.Linen, Target == RPGMoney, Value: Numeric {
    static var to: Self { .init { $0 * 2 + 7 } }
}

public extension StaticConverter where Origin == RPGMoney, Target == RPGMoney.Linen, Value: FloatingPoint {
    static var linen: Self { .init { ($0 - 7) / 2 } }
}

// MARK: Self.Zeni
public extension RPGMoney {
    enum Zeni: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "z" }
    }
}

extension RPGMoney.Zeni: Sendable {}

public extension StaticConverter where Origin == RPGMoney.Zeni, Target == RPGMoney, Value: Numeric {
    static var to: Self { .init { $0 * 3 } }
}

public extension StaticConverter where Origin == RPGMoney, Target == RPGMoney.Zeni, Value: FloatingPoint {
    static var zeni: Self { .init { $0 / 3 } }
}

// MARK: Self.Zero
public extension RPGMoney {
    enum Zero: StaticUnit {
        public typealias Base = RPGMoney

        static var symbol: String { "0" }
    }
}

extension RPGMoney.Zero: Sendable {}

public extension StaticConverter where Origin == RPGMoney.Zero, Target == RPGMoney, Value: Numeric {
    static var to: Self { .init { _ in .zero } }
}

public extension StaticConverter where Origin == RPGMoney, Target == RPGMoney.Zero, Value: Numeric {
    static var zero: Self { .init { _ in .zero } }
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
import Tagged

public extension Tagged where Tag == RPGMoney, RawValue == RPGMoney.Gil.Type {
    static var gil: Self { .init(RPGMoney.Gil.self) }
}

public extension Tagged where Tag == RPGMoney, RawValue == RPGMoney.Linen.Type {
    static var linen: Self { .init(RPGMoney.Linen.self) }
}

public extension Tagged where Tag == RPGMoney, RawValue == RPGMoney.Zeni.Type {
    static var zeni: Self { .init(RPGMoney.Zeni.self) }
}

public extension Tagged where Tag == RPGMoney, RawValue == RPGMoney.Zero.Type {
    static var zero: Self { .init(RPGMoney.Zero.self) }
}

public extension Tagged where Tag == RPGMoney, RawValue: FloatingPoint {
    func constant(_ value: Int) -> Measurement<RPGMoney.Constant, RawValue> {
        .init(rawValue, .init(value: value))
    }
}
