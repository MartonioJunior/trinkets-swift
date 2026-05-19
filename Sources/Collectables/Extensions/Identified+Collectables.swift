//
//  Identified+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections
import SwiftVariety

public extension Identified {
    /// Accesses the value associated with the given key for reading.
    var key: HeterogeneousKey<ID, Value> { .init(id) }
}

// MARK: Value: Trinket
public extension Identified where Value: Trinket, Value.ID == ID {
    /// Wraps any trinket as an `Identified`.
    /// - Parameter trinket: Trinket to be wrapped.
    /// - Returns: A new `Identified` instance.
    static func trinket(_ trinket: Value) -> Self {
        .init(trinket, id: \.id)
    }
}
