//
//  ElectricCurrent.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
import Tagged
import TrinketsUnits

public enum ElectricCurrent: Dimension {
    public typealias BaseUnit = Amperes
}

// MARK: Self.Amperes
public extension ElectricCurrent {
    enum Amperes: StaticUnit {
        public typealias Base = ElectricCurrent
    }
}

#if LocalizedSymbols
public extension ElectricCurrent.Amperes {
    static var symbol: UnitRepresentation {
        .init(symbol: .ElectricCurrent.amperesSymbol, name: SyntaxFunction {
            .ElectricCurrent.amperesName(amount: $0)
        })
    }
}
#endif

public extension Tagged where Tag == ElectricCurrent.Amperes, RawValue: Numeric {
    var electricCurrent: Tagged<ElectricCurrent, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == ElectricCurrent, RawValue: Numeric {
    var amperes: Tagged<ElectricCurrent.Amperes, RawValue> { .init(rawValue) }
}
