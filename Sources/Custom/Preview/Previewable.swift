//
//  Previewable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

public protocol Previewable {}

// MARK: Default Implementation
public extension Previewable {
    func preview<M: Modifier>(
        _ modifiers: some Sequence<M>
    ) -> Self where M.Target == Self {
        modifiers.preview(on: self)
    }
}
