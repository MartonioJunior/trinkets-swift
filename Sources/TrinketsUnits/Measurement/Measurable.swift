//
//  Measurable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/06/2026.
//

/// Measure in a given unit.
public protocol Measurable<Unit, Quantity> {
    /// Unit used in the measure.
    associatedtype Unit: Quantifiable
    /// Type of amount of this measure.
    associatedtype Quantity
    // MARK: Variables
    /// Amount associated with this measure.
    var quantity: Quantity { get }
}
