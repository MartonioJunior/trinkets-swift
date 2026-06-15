//
//  Attribute.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/09/2025.
//

/// Alias for an attribute using a generic modifier.
public typealias AttributeOf<Value> = Attribute<Modify<Value, Void>>
/// Wrapper for a value that can have modifiers applied to it.
/// - Mod: Type of modifier that can be accepted by this attribute.
@propertyWrapper
public struct Attribute<Mod: Modifier> where Mod.Output == Void {
    /// Type representing the value represented by this attribute.
    public typealias Value = Mod.Target
    // MARK: Variables
    /// Base value of the attribute.
    internal var value: Value
    /// List of modifiers applied to a base value.
    /// 
    /// The order of modifiers may affect the result of `wrappedValue`.
    public var modifiers: [Mod]
    /// Base value, before applying any modifiers.
    /// 
    /// Differently from `wrappedValue`, setting this value does not affect any modifiers.
    var base: Value {
        get { value }
        set { value = newValue }
    }
    /// Reference to the attribute.
    public var projectedValue: Self {
        get { self }
        set { self = newValue }
    }
    /// Final value, after applying all modifiers.
    /// 
    /// Setting this property removes all modifiers.
    public var wrappedValue: Value {
        get { modifiers.preview(on: value) }
        set { overwrite(newValue) }
    }
    // MARK: Initializers
    /// Creates a new attribute.
    /// - Parameters:
    ///   - wrappedValue: Base value, before applying any modifiers.
    ///   - modifiers: List of modifiers applied to the base value.
    ///
    public init(wrappedValue: Value, modifiers: [Mod] = []) {
        self.modifiers = modifiers
        self.value = wrappedValue
    }
    // MARK: Methods
    /// Merges all modifiers into the base value.
    ///
    /// After merged into the base value, all modifiers are removed from the attribute.
    public mutating func merge() {
        apply(to: &value)
        clearAllModifiers()
    }
    /// Sets a new value for the attribute, removing all prior modifiers.
    /// - Parameter newValue: New base value of the attribute.
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
    // swiftlint:disable:next missing_docs
    public init(floatLiteral value: Value.FloatLiteralType) {
        self.init(wrappedValue: .init(floatLiteral: value))
    }
}

// MARK: Self: ExpressibleByIntegerLiteral
extension Attribute: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
    // swiftlint:disable:next missing_docs
    public init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(wrappedValue: .init(integerLiteral: value))
    }
}

// MARK: Self: ExpressibleByNilLiteral
extension Attribute: ExpressibleByNilLiteral where Value: ExpressibleByNilLiteral {
    // swiftlint:disable:next missing_docs
    public init(nilLiteral: ()) {
        self.init(wrappedValue: .init(nilLiteral: nilLiteral))
    }
}

// MARK: Self: Modifiable
extension Attribute: Modifiable {
    // swiftlint:disable:next missing_docs
    public mutating func apply(_ modifier: Mod) {
        modifiers.append(modifier)
    }
    // swiftlint:disable:next missing_docs
    public mutating func clearModifiers(where predicate: (Mod) -> Bool) {
        modifiers.removeAll(where: predicate)
    }
    // swiftlint:disable:next missing_docs
    public mutating func clearAllModifiers() {
        modifiers.removeAll()
    }
}

// MARK: Self: Sendable
extension Attribute: Sendable where Mod: Sendable, Mod.Target: Sendable {}
