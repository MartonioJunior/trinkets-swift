//
//  MockModifier.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

import Custom

struct MockModifier<Value> {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
}

// MARK: Self: Equatable
extension MockModifier: Equatable where Value: Equatable {}

// MARK: Self: Modifier
extension MockModifier: Modifier {
    func apply(to target: inout Value) {
        target = value
    }
}

// MARK: Self: Sendable
extension MockModifier: Sendable where Value: Sendable {}
