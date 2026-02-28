//
//  SIFundamentalVector.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/08/2025.
//

import TrinketsUnits

@available(macOS 26.0, *)
public struct SIFundamentalVector<
    let M: Int,
    let S: Int,
    let Kg: Int,
    let A: Int,
    let K: Int,
    let Cd: Int,
    let Mol: Int
> {
    var dimensionality: Dimensionality {
        [
            Length.self: M,
            Time.self: S,
            Mass.self: Kg,
            ElectricCurrent.self: A,
            Temperature.self: K,
            LuminousIntensity.self: Cd,
            SubstanceAmount.self: Mol
        ]
    }
}
