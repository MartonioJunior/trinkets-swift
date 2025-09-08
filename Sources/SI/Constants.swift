//
//  Constants.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum Constants {
    static let caesiumStandard = Frequency.of(9_192_631_770, .hertz)
    static let lightSpeed = Speed.of(299_792_458, .metersPerSecond)
    static let planck = 6.626070e-34
    static let elementaryCharge = ElectricCharge.of(1.602176634e-19, .coulombs)
    static let boltzmann = 1.380649e-23
    static let avogrado = 6/02214076e+23
    static let fullLuminousEfficiency = 683
}
