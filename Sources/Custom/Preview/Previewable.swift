//
//  Previewable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

/// Object that can be previewed for changes.
public protocol Previewable {}

// MARK: Default Implementation
public extension Previewable {
    /// Shows how the instance will be changed by the modifiers.
    /// - Parameter modifiers: List of modifiers to be applied (in order).
    /// - Returns: Target with the given modifications.
    func preview<M: Modifier>(
        _ modifiers: some Sequence<M>
    ) -> Self where M.Target == Self {
        modifiers.preview(on: self)
    }
}
