//
//  Materials.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public struct Material {}

// MARK: Self: Domain
extension Material: Domain {
    public typealias Features = Void
}

// MARK: Default Units
public extension Unit where D == Material {
    static let cloth: Self = .init("cloth")
}
