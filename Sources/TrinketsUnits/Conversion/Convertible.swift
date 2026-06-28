//
//  Convertible.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/09/2025.
//

import Tagged

/// Unit or quantifiable aspect that can be converted to a base.
/// 
/// Works as a marker protocol to allow conversion between different units that share the same base.
public protocol Convertible: Quantifiable {
    /// Type representing the base of conversion.
    associatedtype Base = Self
}
