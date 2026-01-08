//
//  SM64KeyItem.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import Collectables

public enum SM64KeyItem {
    case key(Key)
    case star(SM64Star)
    case block(SM64Cap)
}

// MARK: Self.Key
public extension SM64KeyItem {
    enum Key: String {
        case basement
        case upstairs
    }
}

extension SM64KeyItem.Key: Identifiable {
    public var id: String { "key\(rawValue.uppercased())" }
}

// MARK: Self: Equatable
extension SM64KeyItem: Equatable {}

// MARK: Self: Hashable
extension SM64KeyItem: Hashable {}

// MARK: Self: Trinket
extension SM64KeyItem: Trinket {
    public typealias Value = Int

    public var id: String {
        switch self {
            case let .block(cap): cap.id
            case let .key(key): key.id
            case let .star(star): star.id
        }
    }
}

// MARK: Expanding the Domain
public extension SM64KeyItem {
    var location: SM64Location {
        switch self {
            case let .key(key): key.location
            case let .star(star): star.location
            case let .block(cap): cap.location
        }
    }
}

public extension SM64KeyItem.Key {
    var location: SM64Location {
        switch self {
            case .basement: .bowser(.darkWorld)
            case .upstairs: .bowser(.fireSea)
        }
    }
}
