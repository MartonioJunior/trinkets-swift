//
//  SM64Currency.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import Collectables

public enum SM64Currency: String, CaseIterable {
    case coin
}

extension SM64Currency: Trinket {
    public typealias Value = Int

    public var id: String { rawValue }
}

// MARK: Self: Sendable
extension SM64Currency: Sendable {}
