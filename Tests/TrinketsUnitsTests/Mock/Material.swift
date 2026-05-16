//
//  Materials.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum Material {}

// MARK: Self: Domain
extension Material: Domain {
    public typealias Features = Void
}

// MARK: Default Units
public extension Material {
    enum Cloth: StaticUnit {
        public typealias Base = Material
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == Material, RawValue == Material.Cloth.Type {
    static var cloth: Self { .init(Material.Cloth.self) }
}
