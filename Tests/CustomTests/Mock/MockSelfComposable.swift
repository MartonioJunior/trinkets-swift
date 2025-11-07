//
//  MockSelfComposable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/11/2025.
//

import Custom

internal struct MockSelfComposable<Value: AdditiveArithmetic> {
    var value: Value

    init(_ value: Value = .zero) {
        self.value = value
    }
}

// MARK: Self: Composable
extension MockSelfComposable: Composable {
    func appending(_ value: Value) -> Self {
        .init(self.value + value)
    }

    func removing(_ value: Value) -> Self {
        .init(self.value - value)
    }
}

// MARK: Self: Equatable
extension MockSelfComposable: Equatable {}

// MARK: Self: ExpressibleByArrayLiteral
extension MockSelfComposable: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Value...) {
        self.init(elements.reduce(.zero, +))
    }
}

// MARK: Self: Sendable
extension MockSelfComposable: Sendable where Value: Sendable {}
