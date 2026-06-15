//
//  Modifiable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

/// Type that can have modifiers applied and removed.
public protocol Modifiable {
    /// Type of modifier accepted by this type.
    /// 
    /// When `Mod.Target` == `Self`, this means that it's self-modifiable.
    associatedtype Mod: Modifier = Modify<Self, Void>
    /// Applies a modifier.
    /// - Parameter modifier: Modifier to be applied.
    mutating func apply(_ modifier: Mod)
    /// Removes a set of modifiers based on a given predicate.
    /// - Parameter predicate: Predicate for elements to remove.
    mutating func clearModifiers(where predicate: (Mod) -> Bool)
    /// Removes all modifiers.
    mutating func clearAllModifiers()
}

// MARK: Default Implementation
public extension Modifiable {
    // swiftlint:disable:next missing_docs
    mutating func clearAllModifiers() {
        clearModifiers { _ in true }
    }
}

public extension Modifier where Output == Void {
    /// Creates a modifier that applies this modifier onto a `Modifiable` property.
    /// - Parameter attribute: Property to be changed.
    /// - Returns: A new modifier instance.
    func applicable<M: Modifiable, T>(
        on attribute: WritableKeyPath<T, M>
    ) -> Modify<T, Void> where M.Mod == Self {
        .customize(attribute) { $0.apply(self) }
    }
}
