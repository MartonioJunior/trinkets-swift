//
//  MockMaterial.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/11/2025.
//

import Collectables

public struct MockMaterial {
    public var id: String
}

// MARK: Self: CaseIterable
extension MockMaterial: CaseIterable {
    public static var allCases: [MockMaterial] {
        ["goal", "lollipop", "balloons"]
    }
}

// MARK: Self: Equatable
extension MockMaterial: Equatable {}

// MARK: Self: ExpressibleByStringLiteral
extension MockMaterial: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.id = value
    }
}

// MARK: Self: Sendable
extension MockMaterial: Sendable {}

// MARK: Self: Trinket
extension MockMaterial: Trinket {
    public typealias Value = Int
}
