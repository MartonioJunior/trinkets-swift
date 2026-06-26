//
//  LuminousIntensity.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import Tagged
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

public extension Tagged where Tag == LuminousIntensity.Candela, RawValue: AdditiveArithmetic {
    var luminousIntensity: Tagged<LuminousIntensity, RawValue> { .init(rawValue) }
}

public extension Tagged where Tag == LuminousIntensity, RawValue: AdditiveArithmetic {
    var candela: Tagged<LuminousIntensity.Candela, RawValue> { .init(rawValue) }
}
