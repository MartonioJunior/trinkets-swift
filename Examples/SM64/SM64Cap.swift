//
//  SM64Cap.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import Collectables
import SI
import TrinketsUnits

public enum SM64Cap: String, CaseIterable {
    case metal
    case vanish
    case wing
}

// MARK: Self: Sendable
extension SM64Cap: Sendable {}

// MARK: Self: Trinket
extension SM64Cap: Trinket {
    public var id: String { "\(rawValue)Cap" }
}

// MARK: Expanding the Domain
public extension SM64Cap {
    var blockLocations: [SM64Location] {
        switch self {
            case .wing: [
                .course(.bobOmbBattlefield),
                .course(.lethalLavaLand),
                .course(.shiftingSandLand),
                .course(.rainbowRide),
                location,
                .secret(.wingMarioOverTheRainbow)
            ]
            case .metal: [
                .course(.bigBoosHaunt),
                .course(.hazyMazeCave),
                .course(.direDireDocks),
                location
            ]
            case .vanish: [
                .course(.jollyRogerBay),
                .course(.direDireDocks),
                .course(.snowmansLand),
                .course(.wetDryWorld),
                location
            ]
        }
    }

    var dependencyStars: [SM64Star] {
        switch self {
            case .wing: [
                .course(.bobOmbBattlefield, .fifth),
                .course(.rainbowRide, .sixth),
                .special(.secret(.wingMarioOverTheRainbow))
            ]
            case .metal: [
                .course(.jollyRogerBay, .sixth),
                .course(.direDireDocks, .fifth)
            ]
            case .vanish: [
                .course(.bigBoosHaunt, .sixth),
                .course(.direDireDocks, .fifth),
                .course(.snowmansLand, .fifth),
                .course(.wetDryWorld, .sixth),
                .special(.secret(.cap(.vanishCapUnderTheMoat)))
            ]
        }
    }

    var effectDuration: Time.Measure {
        switch self {
            case .wing: Time.of(1, .minutes)
            case .metal, .vanish: Time.of(20, .seconds)
        }
    }

    var givesInvincibility: Bool {
        switch self {
            case .metal, .vanish: true
            case .wing: false
        }
    }

    var location: SM64Location {
        switch self {
            case .metal: .secret(.cap(.cavernOfTheMetalCap))
            case .vanish: .secret(.cap(.vanishCapUnderTheMoat))
            case .wing: .secret(.cap(.towerOfTheWingCap))
        }
    }
}
