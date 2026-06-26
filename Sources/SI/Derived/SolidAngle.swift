//
//  SolidAngle.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import Tagged
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

public extension Tagged where Tag == SolidAngle.Steradians, RawValue: AdditiveArithmetic {
    var solidAngle: Tagged<SolidAngle, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == SolidAngle, RawValue: AdditiveArithmetic {
    var steradians: Tagged<SolidAngle.Steradians, RawValue> { .init(rawValue) }
}
