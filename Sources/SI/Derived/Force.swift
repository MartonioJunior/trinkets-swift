//
//  Force.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum Force: Dimension {
    public typealias BaseUnit = Newtons

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 1, Time.self: -2]
}

public extension Tagged where Tag == Product<Acceleration, Mass> {
    var asForce: Tagged<Force, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Mass, Acceleration> {
    var asForce: Tagged<Force, RawValue> { .init(rawValue) }
}

// MARK: Self.MetersPerSecond
public extension Force {
    enum Newtons: StaticUnit {
        public typealias Base = Force
    }
}

#if LocalizedSymbols
public extension Force.Newtons {
    static var symbol: UnitRepresentation {
        .init(symbol: .Force.newtonsSymbol, name: SyntaxFunction {
            .Force.newtonsName(amount: $0)
        })
    }
}
#endif // LocalizedSymbols

public extension Tagged where Tag == Force.Newtons, RawValue: Numeric {
    var force: Self { .init(rawValue) }
}

public extension Tagged where Tag == Force, RawValue: Numeric {
    var newtons: Self { .init(rawValue) }
}
