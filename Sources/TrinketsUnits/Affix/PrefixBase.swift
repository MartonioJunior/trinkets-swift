//
//  PrefixBase.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/04/2026.
//

/// Basis for an unit prefix.
public protocol PrefixBase {
    /// Numerical base used by this prefix.
    static var base: Int { get }
}
