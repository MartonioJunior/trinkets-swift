//
//  Domain.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/06/2025.
//

/// Representable field of activity of knowledge through one or more units.
/// 
/// This type is mainly used to define unit representations for a given type.
public protocol Domain {
    /// Symbol associated with the unit.
    associatedtype Symbol = String
}
