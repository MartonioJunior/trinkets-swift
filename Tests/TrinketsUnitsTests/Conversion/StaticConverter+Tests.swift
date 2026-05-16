//
//  StaticConverter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

import Tagged
import Testing
@testable import TrinketsUnits

struct StaticConverterTests {
    // MARK: Default Implementation
    @Test("Creates a converter from a value function")
    func initializer() {
        let f: @Sendable (Double) -> Double = { $0 * 2 }
        let result = StaticConverter<Material, RPGMoney, Double>(f)
        #expect(result.f(5) == f(5))
    }
}
