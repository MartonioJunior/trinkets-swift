//
//  Identified+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections
import SwiftVariety

public extension Identified {
    var key: HeterogeneousKey<ID, Value> { .init(id) }
}

// MARK: Value: Trinket
public extension Identified where Value: Trinket, Value.ID == ID {
    static func trinket(_ trinket: Value) -> Self {
        .init(trinket, id: \.id)
    }
}
