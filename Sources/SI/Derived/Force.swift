//
//  Force.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import TrinketsUnits

public enum Force: Dimension {
    public typealias BaseUnit = Newtons

    public static let dimensionality: Dimensionality = [Mass.self: 1, Length.self: 1, Time.self: -2]
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
#endif

public extension StaticConverter where Origin == Force.Newtons, Target == Force, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == Force, Target == Force.Newtons, Value: Numeric {
    static var newtons: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Force, RawValue == Force.Newtons.Type {
    static var newtons: Self { .init(Force.Newtons.self) }
}

public extension Tagged where Tag == Product<Acceleration, Mass> {
    var asForce: Tagged<Force, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == Product<Mass, Acceleration> {
    var asForce: Tagged<Force, RawValue> { .init(rawValue) }
}
