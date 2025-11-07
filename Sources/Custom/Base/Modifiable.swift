//
//  Modifiable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

public protocol Modifiable {
    associatedtype Mod: Modifier = Modify<Self, Void>

    mutating func apply(_ modifier: Mod)
    mutating func clearModifiers(where predicate: (Mod) -> Bool)
    mutating func clearAllModifiers()
}

// MARK: Default Implementation
public extension Modifiable {
    mutating func clearAllModifiers() {
        clearModifiers { _ in true }
    }
}

public extension Modifier where Output == Void {
    func applicable<M: Modifiable, T>(
        on attribute: WritableKeyPath<T, M>
    ) -> Modify<T, Void> where M.Mod == Self {
        .customize(attribute) { $0.apply(self) }
    }
}
