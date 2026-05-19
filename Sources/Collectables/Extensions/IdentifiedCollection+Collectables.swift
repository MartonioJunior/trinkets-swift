//
//  IdentifiedCollection+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections
import SwiftVariety

public extension _IdentifiedCollection {
    /// Accesses the value associated with the given key for reading.
    /// - Parameter key: Heterogeneous key to obtain the element.
    /// - Returns: The retrieved value stored at the `key`'s id, `nil` otherwise.
    subscript(key: HeterogeneousKey<ID, Element>) -> Element? { self[id: key.id] }
}

public extension _MutableIdentifiedCollection {
    /// Accesses the value associated with the given key for reading or writing.
    /// - Parameter key: Heterogeneous key to access the element.
    /// - Returns: The retrieved value stored at the `key`'s id, `nil` otherwise.
    subscript(key: HeterogeneousKey<ID, Element>) -> Element? {
        get { self[id: key.id] }
        set { self[id: key.id] = newValue }
    }
}
