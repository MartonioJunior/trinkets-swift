//
//  Stat.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/09/2025.
//

public typealias Slot<Value> = Stat<Modify<Value?, Void>>
public typealias StatOf<Value> = Stat<Modify<Value, Void>>


@propertyWrapper
public struct Stat<Mod: Modifier> where Mod.Output == Void {
    public typealias Value = Mod.Target

    // MARK: Variables
    internal var attribute: Attribute<Mod>

    var base: Value {
        get { attribute.base }
        set { attribute.base = newValue }
    }

    public var projectedValue: Self {
        get { self }
        set { self = newValue }
    }

    public var wrappedValue: Value { attribute.wrappedValue }

    // MARK: Initializers
    public init(wrappedValue: Value, modifiers: [Mod] = []) {
        self.attribute = .init(wrappedValue: wrappedValue, modifiers: modifiers)
    }

    // MARK: Methods
    public mutating func overwrite(_ newValue: Value) {
        attribute.overwrite(newValue)
    }
}

// MARK: Self: Customizable
extension Stat: Customizable {
    public var modifiers: [Mod] { attribute.modifiers }
}

// MARK: Self: Equatable
extension Stat: Equatable where Mod: Equatable, Mod.Target: Equatable {}

// MARK: Self: ExpressibleByFloatLiteral
extension Stat: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(wrappedValue: .init(floatLiteral: value))
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Stat: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(wrappedValue: .init(integerLiteral: value))
    }
}

// MARK: Self: ExpressibleByNilLiteral
extension Stat: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(wrappedValue: .init(nilLiteral: nilLiteral))
    }
}

// MARK: Self: Modifiable
extension Stat: Modifiable {
    public mutating func apply(_ modifier: Mod) {
        attribute.apply(modifier)
    }

    public mutating func clearModifiers(where predicate: (Mod) -> Bool) {
        attribute.clearModifiers(where: predicate)
    }

    public mutating func clearAllModifiers() {
        attribute.clearAllModifiers()
    }
}

// MARK: Self: Sendable
extension Stat: Sendable where Mod: Sendable, Mod.Target: Sendable {}
