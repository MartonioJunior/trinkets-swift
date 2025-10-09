//
//  Collectable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/07/2025.
//

import TrinketsUnits

public protocol Collectable: Trinket where ID == String, Value == Bool {}

// MARK: Unit (EX)
public extension Unit where D: Collectable {
    init(collectable: D, symbol: D.Symbol = "\(D.self)") {
        self = .trinket(collectable, symbol: symbol)
    }
}
