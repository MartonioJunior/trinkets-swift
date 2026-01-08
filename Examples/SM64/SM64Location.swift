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
    enum Secret: CaseIterable, Equatable, Hashable {
        case princessSecretSlide
        case secretAquarium
        case wingMarioOverTheRainbow
        case cap(Cap)

        public static var allCases: [SM64Location.Secret] {
            [.princessSecretSlide, .secretAquarium, .wingMarioOverTheRainbow] + Cap.allCases.map { .cap($0) }
        }
    }
}

public extension SM64Location.Secret {
    enum Cap: String, CaseIterable, Equatable, Hashable {
        case towerOfTheWingCap
        case cavernOfTheMetalCap
        case vanishCapUnderTheMoat
    }
}

extension SM64Location.Secret.Cap: Identifiable {
    public var id: String { rawValue }
}

extension SM64Location.Secret: Identifiable {
    public var id: String {
        switch self {
            case let .cap(cap): cap.id
            case .princessSecretSlide: "princessSecretSlide"
            case .secretAquarium: "secretAquarium"
            case .wingMarioOverTheRainbow: "wingMarioOverTheRainbow"
        }
    }
}

// MARK: Self: Trinket
extension SM64Location: Trinket {
    public var id: String {
        switch self {
            case let .bowser(bowser): bowser.id
            case let .course(course): course.id
            case let .castle(castle): castle.id
            case let .secret(secret): secret.id
        }
    }
}
