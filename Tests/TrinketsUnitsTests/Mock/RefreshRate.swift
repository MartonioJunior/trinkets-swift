//
//  RefreshRate.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum RefreshRate {}

// MARK: Self.Cinema
public extension RefreshRate {
    // 24fps
    enum Cinema: StaticUnit {
        public typealias Base = RefreshRate
    }
}

public extension StaticConverter where Origin == RefreshRate.Cinema, Target == RefreshRate, Value: Numeric {
    static var to: Self { .init { $0 * 24 } }
}

public extension StaticConverter where Origin == RefreshRate, Target == RefreshRate.Cinema, Value: FloatingPoint {
    static var cinema: Self { .init { $0 / 24 } }
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

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == RefreshRate, RawValue == RefreshRate.Cinema.Type {
    static var cinema: Self { .init(RefreshRate.Cinema.self) }
}
