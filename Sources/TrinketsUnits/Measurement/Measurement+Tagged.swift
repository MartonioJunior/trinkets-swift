//
//  Measurement+Tagged.swift
//  Trinkets
//
//  Created by Martônio Júnior on 15/05/2026.
//

import Tagged

public extension Measurement {
    /// Creates a measurement from a tagged value.
    /// - Parameter tagged: Tagged value.
    init<N: StaticUnit>(_ tagged: Tagged<N, Value>) where UnitType == N.Type {
        self.init(tagged.rawValue)
    }
    /// Transforms the measure back into a tagged value.
    /// - Returns: A tagged value.
    func tagged<N: StaticUnit>() -> Tagged<N, Value> where UnitType == N.Type {
        .init(value)
    }
}
