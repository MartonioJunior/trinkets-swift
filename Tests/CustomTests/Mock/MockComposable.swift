//
//  MockComposable.swift
//  Core
//
//  Created by Martônio Júnior on 30/05/2025.
//

import Custom

internal struct MockComposable<Value, Result> {
    var value: Value
    var insert: @Sendable (Value, Value) -> Result
    var dissolve: @Sendable (Value, Value) -> Result

    init(
        _ value: Value,
        insert: @escaping @Sendable (Value, Value) -> Result,
        dissolve: @escaping @Sendable (Value, Value) -> Result
    ) {
        self.value = value
        self.insert = insert
        self.dissolve = dissolve
    }
}

// MARK: DotSyntax
extension MockComposable {
    static func additive(_ value: Value = .zero) -> Self where Value == Result, Value: AdditiveArithmetic {
        .init(value, insert: +, dissolve: -)
    }
}

// MARK: Self: Appendable
extension MockComposable: Appendable {
    func appending(_ value: Value) -> Result {
        insert(self.value, value)
    }
}

// MARK: Self: Equatable
extension MockComposable: Equatable where Value: Equatable, Result: Equatable {
    static func == (lhs: MockComposable<Value, Result>, rhs: MockComposable<Value, Result>) -> Bool {
        lhs.value == rhs.value
    }
}

// MARK: Self: Removable
extension MockComposable: Removable {
    func removing(_ value: Value) -> Result {
        dissolve(self.value, value)
    }
}

// MARK: Self: Sendable
extension MockComposable: Sendable where Value: Sendable, Result: Sendable {}
