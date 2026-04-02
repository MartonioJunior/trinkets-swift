//
//  IdentifiedCollection+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections
import SwiftVariety

public extension _IdentifiedCollection {
    subscript(key: HeterogeneousKey<ID, Element>) -> Element? { self[id: key.id] }
}

public extension _MutableIdentifiedCollection {
    subscript(key: HeterogeneousKey<ID, Element>) -> Element? {
        get { self[id: key.id] }
        set { self[id: key.id] = newValue }
    }
}
