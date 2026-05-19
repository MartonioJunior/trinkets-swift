//
//  ElectricCurrent.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Notation
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

public extension StaticConverter where Origin == ElectricCurrent.Amperes, Target == ElectricCurrent, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == ElectricCurrent, Target == ElectricCurrent.Amperes, Value: Numeric {
    static var amperes: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == ElectricCurrent, RawValue == ElectricCurrent.Amperes.Type {
    static var amperes: Self { .init(ElectricCurrent.Amperes.self) }
}
