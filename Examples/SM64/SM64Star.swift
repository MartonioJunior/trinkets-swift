//
//  SM64Star.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

import Collectables

public enum SM64Star {
    case bowser(SM64Location.Bowser)
    case cap(SM64Cap)
    case course(SM64Location.Course, Mission)
    case mips(Mips)
    case special(Special)
    case toad(Toad)
}

// MARK: Self.Mips
public extension SM64Star {
    enum Mips: UInt, CaseIterable {
        case first
        case second
    }
}

extension SM64Star.Mips: Hashable {}

// MARK: Self.Mission
public extension SM64Star {
    enum Mission: UInt, CaseIterable {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
        case hundredCoins
    }
}

extension SM64Star.Mission: Hashable {}

extension SM64Star.Mission: Identifiable {
    public var id: UInt { rawValue }
}

// MARK: Self.Special
public extension SM64Star {
    enum Special {
        case secret(SM64Location.Secret)
        case princessPeachSlideTimed
    }
}

extension SM64Star.Special: Hashable {}

extension SM64Star.Special: Identifiable {
    public var id: String {
        switch self {
            case let .secret(secret):
                "\(secret.rawValue)"
            case .princessPeachSlideTimed:
                "\(SM64Location.Secret.princessSecretSlide.rawValue))Timed"
        }
    }
}

// MARK: Self.Toad
public extension SM64Star {
    enum Toad: UInt, CaseIterable {
        case first
        case second
        case third
    }
}

// MARK: Self: Collectable
extension SM64Star: Collectable {
    public var id: String {
        switch self {
            case let .bowser(bowser):
                "bowser\(bowser.rawValue)"
            case let .course(course, mission):
                "\(course.rawValue)-\(mission.id)"
            case let .cap(cap):
                "\(cap.id)cap"
            case let .mips(mips):
                "mips\(mips.rawValue)"
            case let .special(secret):
                "special\(secret)"
            case let .toad(toad):
                "toad\(toad.rawValue)"
        }
    }
}

// MARK: Self: Hashable
extension SM64Star: Hashable {}

// MARK: Expanding the Domain
var canTheEelComeOutToPlay: SM64Star { .course(.jollyRogerBay, .second) }
var bowserInTheSkyStar: SM64Star { .bowser(.sky) }
var princessPeachSlideIn21Seconds: SM64Star { .special(.princessPeachSlideTimed) }

public extension SM64Star {
    var location: SM64Location {
        switch self {
            case let .bowser(bowser): .bowser(bowser)
            case let .cap(cap): cap.location
            case let .course(course, _): .course(course)
            case let .mips(mips): mips.location
            case let .special(special): special.location
            case let .toad(toad): toad.location
        }
    }
}

public extension SM64Star.Mips {
    var location: SM64Location { .castle(.basement) }
}

public extension SM64Star.Special {
    var location: SM64Location {
        switch self {
            case let .secret(secret): .secret(secret)
            case .princessPeachSlideTimed: .secret(.princessSecretSlide)
        }
    }
}

public extension SM64Star.Toad {
    var location: SM64Location {
        switch self {
            case .first: .castle(.basement)
            case .second, .third: .castle(.secondFloor)
        }
    }
}
