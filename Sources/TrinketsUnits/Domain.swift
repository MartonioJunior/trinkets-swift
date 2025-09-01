//
//  Domain.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/06/2025.
//

public protocol Domain {
    associatedtype Features
    typealias Symbol = String
}

// MARK: Default Implementation
public extension Domain {
    typealias Unit = TrinketsUnits.Unit<Self>
}
