//
//  SM64Cap.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import Collectables

public enum SM64Cap: String, CaseIterable {
    case metal
    case vanish
    case wing
}

// MARK: Self: Collectable
extension SM64Cap: Collectable {
    public var id: String { "\(rawValue)Cap" }
}

// MARK: Self: Sendable
extension SM64Cap: Sendable {}

// MARK: Expanding the Domain
public extension SM64Cap {
    var location: SM64Location {
        switch self {
            case .metal: .course(.hazyMazeCave)
            case .vanish: .castle(.outdoors)
            case .wing: .castle(.firstFloor)
        }
    }
}
