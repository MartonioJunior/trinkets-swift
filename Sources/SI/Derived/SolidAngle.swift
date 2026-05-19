//
//  SolidAngle.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import TrinketsUnits

public enum SolidAngle: Dimension {
    public typealias BaseUnit = Steradians

    public static let dimensionality: Dimensionality = .dimensionless
}

// MARK: Self.Candela
public extension SolidAngle {
    enum Steradians: StaticUnit {
        public typealias Base = SolidAngle
    }
}

#if LocalizedSymbols
public extension SolidAngle.Steradians {
    static var symbol: UnitRepresentation {
        .init(symbol: .SolidAngle.steradiansSymbol, name: SyntaxFunction {
            .SolidAngle.steradiansName(amount: $0)
        })
    }
}
#endif

public extension StaticConverter where Origin == SolidAngle.Steradians, Target == SolidAngle, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == SolidAngle, Target == SolidAngle.Steradians, Value: Numeric {
    static var steradians: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == SolidAngle, RawValue == SolidAngle.Steradians.Type {
    static var steradians: Self { .init(SolidAngle.Steradians.self) }
}
