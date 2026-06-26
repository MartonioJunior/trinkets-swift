//
//  RefreshRate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
import TrinketsUnits

public enum RefreshRate {}

// MARK: Self.Cinema
public extension RefreshRate {
    // 24fps
    enum Cinema: StaticUnit {
        public typealias Base = RefreshRate
    }
}

public extension Tagged where Tag == RefreshRate.Cinema, RawValue: Numeric {
    var refreshRate: Tagged<RefreshRate, RawValue> { .init(rawValue * 24) }
}

public extension Tagged where Tag == RefreshRate, RawValue: FloatingPoint {
    var cinema: Tagged<RefreshRate.Cinema, RawValue> { .init(rawValue / 24) }
}

// MARK: Self.FPS
public extension RefreshRate {
    struct FPS: Convertible {
        public typealias Base = RefreshRate

        var refreshRate: Int
    }
}

extension RefreshRate.FPS: CustomStringConvertible {
    public var description: String { "\(refreshRate)fps" }
}

extension RefreshRate.FPS: Equatable, Sendable {}

// MARK: Self: Dimension
extension RefreshRate: Dimension {
    public typealias BaseUnit = FPS
}

// MARK: Self: Sendable
extension RefreshRate: Sendable {}
