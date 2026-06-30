//
//  SlangPrefix.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/08/2025.
//

import TrinketsUnits

public enum SlangPrefix: UnitPrefixSystem {
    public static var base: Int { 4 }
}

// MARK: Self.Tubular
public extension SlangPrefix {
    enum Tubular: UnitPrefix {
        public typealias Base = SlangPrefix

        public static var exponent: Int { 2 }

        static var symbol: String { "hiHI" }
    }
}

// MARK: Self.Whoa
public extension SlangPrefix {
    enum Whoa: UnitPrefix {
        public typealias Base = SlangPrefix

        public static var exponent: Int { 11 }

        static var symbol: String { "ö" }
    }
}

// MARK: Tagged (EX)
import Tagged

public extension Tagged where Tag == SlangPrefix, RawValue == SlangPrefix.Tubular.Type {
    static var tubular: Self { .init(SlangPrefix.Tubular.self) }
}

public extension Tagged where Tag == SlangPrefix, RawValue == SlangPrefix.Whoa.Type {
    static var whoa: Self { .init(SlangPrefix.Whoa.self) }
}
