//
//  SubstanceAmount.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import TrinketsUnits

public enum SubstanceAmount: Dimension {
    public typealias BaseUnit = Moles
}

// MARK: Self.Moles
public extension SubstanceAmount {
    enum Moles: StaticUnit {
        public typealias Base = SubstanceAmount
    }
}

public extension SubstanceAmount.Moles {
    static var symbol: UnitRepresentation {
        .init(symbol: .SubstanceAmount.molesSymbol, name: SyntaxFunction {
            .SubstanceAmount.molesName(amount: $0)
        })
    }
}

public extension StaticConverter where Origin == SubstanceAmount.Moles, Target == SubstanceAmount, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == SubstanceAmount, Target == SubstanceAmount.Moles, Value: Numeric {
    static var moles: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == SubstanceAmount, RawValue == SubstanceAmount.Moles.Type {
    static var moles: Self { .init(SubstanceAmount.Moles.self) }
}
