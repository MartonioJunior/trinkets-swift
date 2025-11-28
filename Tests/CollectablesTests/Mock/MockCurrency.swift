//
//  MockCurrency.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/11/2025.
//

import Collectables

public enum MockCurrency: String, CaseIterable {
    case coin
    case feather
    case ticket
}

// MARK: Self: Equatable
extension MockCurrency: Equatable {}

// MARK: Self: Trinket
extension MockCurrency: Trinket {
    public typealias Value = Int

    public var id: String { rawValue }
}

// MARK: Self: Sendable
extension MockCurrency: Sendable {}
