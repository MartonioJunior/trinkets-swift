//
//  SM64Location.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import Collectables

public enum SM64Location {
    case bowser(Bowser)
    case castle(Castle)
    case course(Course)
    case secret(Secret)
}

// MARK: Self.Bowser
public extension SM64Location {
    enum Bowser: String {
        case darkWorld
        case fireSea
        case sky
    }
}

extension SM64Location.Bowser: Identifiable {
    public var id: String { "bowser\(rawValue.uppercased())" }
}

// MARK: Self.Castle
public extension SM64Location {
    enum Castle: String, CaseIterable {
        case outdoors
        case firstFloor
        case basement
        case secondFloor
        case thirdFloor
    }
}

extension SM64Location.Castle: Identifiable {
    public var id: String { "castle\(rawValue.uppercased())" }
}

// MARK: Self.Course
public extension SM64Location {
    enum Course: String, CaseIterable {
        case bobOmbBattlefield
        case whompsFortress
        case jollyRogerBay
        case coolCoolMountain
        case bigBoosHaunt
        case hazyMazeCave
        case lethalLavaLand
        case shiftingSandLand
        case direDireDocks
        case snowmansLand
        case wetDryWorld
        case tallTallMountain
        case tinyHugeIsland
        case tickTockClock
        case rainbowRide
    }
}

extension SM64Location.Course: Identifiable {
    public var id: String { rawValue }
}

// MARK: Self.Secret
public extension SM64Location {
    enum Secret: String, CaseIterable {
        case princessSecretSlide
        case secretAquarium
        case wingMarioOverTheRainbow
    }
}

extension SM64Location.Secret: Identifiable {
    public var id: String { rawValue }
}

// MARK: Self: Trinket
extension SM64Location: Trinket {
    public typealias Value = Never

    public var id: String {
        switch self {
            case let .bowser(bowser): bowser.id
            case let .course(course): course.id
            case let .castle(castle): castle.id
            case let .secret(secret): secret.id
        }
    }
}

// MARK: Expanding the Domain
public extension SM64Location {
    var keyItemsForAccess: [SM64KeyItem] {
        switch self {
            case .castle(.outdoors),
                .castle(.firstFloor),
                .course(.bobOmbBattlefield):
                []
            case .course(.whompsFortress),
                .secret(.princessSecretSlide):
                fatalError() // 1⭐
            case .course(.jollyRogerBay),
                .course(.coolCoolMountain),
                .secret(.secretAquarium):
                fatalError() // 3⭐
            case .bowser(.darkWorld):
                fatalError() // 8⭐
            case .course(.bigBoosHaunt):
                fatalError() // 12⭐
            case .castle(.basement),
                .course(.hazyMazeCave),
                .course(.lethalLavaLand),
                .course(.shiftingSandLand):
                [.key(.basement)]
            case .course(.direDireDocks):
                fatalError() // 30⭐
            case .bowser(.fireSea):
                fatalError() // [.key(.basement), .star(.course(.direDireDocks, .first)), 31⭐]
            case .castle(.secondFloor),
                .course(.tallTallMountain),
                .course(.snowmansLand),
                .course(.wetDryWorld),
                .course(.tinyHugeIsland):
                [.key(.upstairs)]
            case .castle(.thirdFloor),
                .course(.tickTockClock),
                .course(.rainbowRide),
                .secret(.wingMarioOverTheRainbow):
                fatalError() // [.key(.upstairs), 50⭐]
            case .bowser(.sky):
                fatalError() // [.key(.upstairs), 70⭐]
        }
    }
}
