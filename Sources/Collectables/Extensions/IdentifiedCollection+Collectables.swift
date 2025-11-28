//
//  IdentifiedCollection+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections

public extension _IdentifiedCollection {
    subscript(key: IDKey<ID, Element>) -> Element? { self[id: key.referenceID] }
}

public extension _MutableIdentifiedCollection {
    subscript(key: IDKey<ID, Element>) -> Element? {
        get { self[id: key.referenceID] }
        set { self[id: key.referenceID] = newValue }
    }
}
