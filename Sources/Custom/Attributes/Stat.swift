//
//  Stat.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/09/2025.
//

/// Alias for a stat that uses a generic modifier.
public typealias StatOf<Value> = Stat<Modify<Value, Void>>
/// Wrapper for an attribute where it's modifiers can't be merged into the base value.
@propertyWrapper
public struct Stat<Mod: Modifier> where Mod.Output == Void {
    /// Type representing the value represented by this stat.
    public typealias Value = Mod.Target
    // MARK: Variables
    /// Attribute that powers this stat.
    internal var attribute: Attribute<Mod>
    /// Base value, before applying any modifiers.
    /// 
    /// Differently from `wrappedValue`, setting this value does not affect any modifiers.
    var base: Value {
        get { attribute.base }
        set { attribute.base = newValue }
    }
    /// Reference to the stat.
    public var projectedValue: Self {
        get { self }
        set { self = newValue }
    }
    /// Final value, after applying all modifiers.
    /// 
    /// Setting this property removes all modifiers.
    public var wrappedValue: Value { attribute.wrappedValue }
    // MARK: Initializers
    /// A description
    /// - Parameters:
    ///   - wrappedValue:
    ///   - modifiers:
    ///
    public init(wrappedValue: Value, modifiers: [Mod] = []) {
        self.attribute = .init(wrappedValue: wrappedValue, modifiers: modifiers)
    }
    // MARK: Methods
    /// Sets a new value for the attribute, removing all prior modifiers.
    /// - Parameter newValue: New base value of the attribute.
    public mutating func overwrite(_ newValue: Value) {
        attribute.overwrite(newValue)
    }
}

// MARK: Self: Customizable
extension Stat: Customizable {
    // swiftlint:disable:next missing_docs
    public var modifiers: [Mod] { attribute.modifiers }
}

// MARK: Self: Equatable
extension Stat: Equatable where Mod: Equatable, Mod.Target: Equatable {}

// MARK: Self: ExpressibleByFloatLiteral
extension Stat: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    // swiftlint:disable:next missing_docs
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(wrappedValue: .init(floatLiteral: value))
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Stat: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    // swiftlint:disable:next missing_docs
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(wrappedValue: .init(integerLiteral: value))
    }
}

// MARK: Self: ExpressibleByNilLiteral
extension Stat: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    // swiftlint:disable:next missing_docs
    public init(nilLiteral: ()) {
        self.init(wrappedValue: .init(nilLiteral: nilLiteral))
    }
}

// MARK: Self: Modifiable
extension Stat: Modifiable {
    // swiftlint:disable:next missing_docs
    public mutating func apply(_ modifier: Mod) {
        attribute.apply(modifier)
    }
    // swiftlint:disable:next missing_docs
    public mutating func clearModifiers(where predicate: (Mod) -> Bool) {
        attribute.clearModifiers(where: predicate)
    }
    // swiftlint:disable:next missing_docs
    public mutating func clearAllModifiers() {
        attribute.clearAllModifiers()
    }
}

// MARK: Self: Sendable
extension Stat: Sendable where Mod: Sendable, Mod.Target: Sendable {}
