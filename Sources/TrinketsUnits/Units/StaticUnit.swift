//
//  StaticUnit.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/04/2026.
//

/// Unit where it's features are statically defined.
/// 
/// Works as a marker protocol for non-instantiable types (e.g. enums with no cases)
public protocol StaticUnit: Quantifiable, Convertible where Base: Domain {}
