//
//  MockItem.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/12/2025.
//

import Inventory
import TrinketsUnits

struct MockItem {
    var id: String
}

// MARK: DotSyntax
extension MockItem {
    static func number(_ value: Int) -> Self { .init(id: "\(value)") }
    static func text(_ value: String) -> Self { .init(id: value) }
}

// MARK: Self: Comparable
extension MockItem: Comparable {
    static func < (lhs: MockItem, rhs: MockItem) -> Bool {
        lhs.id < rhs.id
    }
}

// MARK: Self: Equatable
extension MockItem: Equatable {}

// MARK: Self: Identifiable
extension MockItem: Identifiable {}

// MARK: Self: Measurable
extension MockItem: Measurable {
    typealias Value = Tally
}

// MARK: Self: Sendable
extension MockItem: Sendable {}
