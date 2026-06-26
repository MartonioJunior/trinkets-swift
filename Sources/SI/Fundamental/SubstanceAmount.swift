//
//  SubstanceAmount.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import Tagged
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

#if LocalizedSymbols
public extension SubstanceAmount.Moles {
    static var symbol: UnitRepresentation {
        .init(symbol: .SubstanceAmount.molesSymbol, name: SyntaxFunction {
            .SubstanceAmount.molesName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == SubstanceAmount.Moles, RawValue: Numeric {
    var substanceAmount: Tagged<SubstanceAmount, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == SubstanceAmount, RawValue: Numeric {
    var moles: Tagged<SubstanceAmount.Moles, RawValue> { .init(rawValue) }
}
