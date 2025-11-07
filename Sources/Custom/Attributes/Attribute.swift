//
//  Attribute.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/09/2025.
//

public typealias AttributeSlot<Value> = Attribute<Modify<Value?, Void>>
public typealias AttributeOf<Value> = Attribute<Modify<Value, Void>>

@propertyWrapper
public struct Attribute<Mod: Modifier> where Mod.Output == Void {
    public typealias Value = Mod.Target

    // MARK: Variables
    internal var value: Value
    public var modifiers: [Mod]

    var base: Value {
        get { value }
        set { value = newValue }
    }

    public var projectedValue: Self {
        get { self }
        set { self = newValue }
    }

    public var wrappedValue: Value {
        get { modifiers.preview(on: value) }
        set { overwrite(newValue) }
    }

    // MARK: Initializers
    public init(wrappedValue: Value, modifiers: [Mod] = []) {
        self.modifiers = modifiers
        self.value = wrappedValue
    }

    // MARK: Methods
    public mutating func merge() {
        apply(to: &value)
        clearAllModifiers()
    }

    public mutating func overwrite(_ newValue: Value) {
        value = newValue
        clearAllModifiers()
    }
}

// MARK: Self: Customizable
extension Attribute: Customizable {}

// MARK: Self: Equatable
extension Attribute: Equatable where Mod: Equatable, Mod.Target: Equatable {}

// MARK: Self: ExpressibleByFloatLiteral
extension Attribute: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(wrappedValue: .init(floatLiteral: value))
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Attribute: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(wrappedValue: .init(integerLiteral: value))
    }
}

// MARK: Self: ExpressibleByNilLiteral
extension Attribute: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(wrappedValue: .init(nilLiteral: nilLiteral))
    }
}

// MARK: Self: Modifiable
extension Attribute: Modifiable {
    public mutating func apply(_ modifier: Mod) {
        modifiers.append(modifier)
    }

    public mutating func clearModifiers(where predicate: (Mod) -> Bool) {
        modifiers.removeAll(where: predicate)
    }

    public mutating func clearAllModifiers() {
        modifiers.removeAll()
    }
}

// MARK: Self: Sendable
extension Attribute: Sendable where Mod: Sendable, Mod.Target: Sendable {}
