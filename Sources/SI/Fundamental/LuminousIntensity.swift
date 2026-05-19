//
//  LuminousIntensity.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum LuminousIntensity: Dimension {
    public typealias BaseUnit = Candela
}

// MARK: Self.Candela
public extension LuminousIntensity {
    enum Candela: StaticUnit {
        public typealias Base = LuminousIntensity
    }
}

#if LocalizedSymbols
public extension LuminousIntensity.Candela {
    static var symbol: UnitRepresentation {
        .nonPluralized(symbol: .LuminousIntensity.candelaSymbol, name: .LuminousIntensity.candelaName)
    }
}
#endif

public extension StaticConverter where Origin == LuminousIntensity.Candela, Target == LuminousIntensity, Value: Numeric {
    static var to: Self { .init { $0 } }
}

public extension StaticConverter where Origin == LuminousIntensity, Target == LuminousIntensity.Candela, Value: Numeric {
    static var candela: Self { .init { $0 } }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == LuminousIntensity, RawValue == LuminousIntensity.Candela.Type {
    static var candela: Self { .init(LuminousIntensity.Candela.self) }
}
