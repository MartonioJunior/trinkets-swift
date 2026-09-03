//
//  Block.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

import MatheRange
/// Boundary of mapped values.
public protocol Block<Instant, Element> {
    /// Type of instant accepted by this block.
    associatedtype Instant = Mask.Bound
    /// Type of boundary used by this block.
    associatedtype Mask: Boundary
    /// Type of value that can be retrieved from this block.
    associatedtype Element
    /// Boundary that is occupied by the block.
    var mask: Mask { get }
    /// Retrieves the expected element at a given instant.
    /// - Parameter instant: Instant.
    /// - Returns: Element present at the given instant.
    func element(on instant: Instant) -> Element
}

// MARK: Instant == Mask.Bound
public extension Block where Instant == Mask.Bound {
    /// Retrieves a element only when instant is within the mask.
    /// - Parameter instant: Instant.
    /// - Returns: Element present at the given instant, `nil` when the mask blocks retrieval.
    func maskedElement(at instant: Instant) -> Element? {
        guard mask.contains(instant) else { return nil }

        return element(on: instant)
    }
}
