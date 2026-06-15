//
//  ModifierGroup.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/07/2025.
//

/// Collection of modifiers that are grouped together.
/// - Mod: Type of modifier used by this group. Does not have an output.
public struct ModifierGroup<Mod: Modifier> where Mod.Output == Void {
    // swiftlint:disable:next missing_docs
    public var modifiers: [Mod]
    // MARK: Initializers
    /// Creates a new modifier group.
    /// - Parameter modifiers: List of modifiers in this group.
    public init(_ modifiers: [Mod] = []) {
        self.modifiers = modifiers
    }
}

// MARK: Self: Customizable
extension ModifierGroup: Customizable {}

// MARK: Self: Equatable
extension ModifierGroup: Equatable where Mod: Equatable {}

// MARK: ExpressibleByArrayLiteral
extension ModifierGroup: ExpressibleByArrayLiteral {
    // swiftlint:disable:next missing_docs
    public init(arrayLiteral elements: Mod...) {
        self.init(elements)
    }
}

// MARK: Self: Modifier
extension ModifierGroup: Modifier {
    // swiftlint:disable:next missing_docs
    public func apply(to target: inout Mod.Target) {
        modifiers.forEach { $0.apply(to: &target) }
    }
}

// MARK: Self: Modifiable
extension ModifierGroup: Modifiable {
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
extension ModifierGroup: Sendable where Mod: Sendable {}
