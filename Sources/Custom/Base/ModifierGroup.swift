//
//  ModifierGroup.swift
//  Trinkets
//
//  Created by Martônio Júnior on 13/07/2025.
//

public struct ModifierGroup<Mod: Modifier> where Mod.Output == Void {
    public var modifiers: [Mod]

    // MARK: Initializers
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
    public init(arrayLiteral elements: Mod...) {
        self.init(elements)
    }
}

// MARK: Self: Modifier
extension ModifierGroup: Modifier {
    public func apply(to target: inout Mod.Target) {
        modifiers.forEach { $0.apply(to: &target) }
    }
}

// MARK: Self: Modifiable
extension ModifierGroup: Modifiable {
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
extension ModifierGroup: Sendable where Mod: Sendable {}
