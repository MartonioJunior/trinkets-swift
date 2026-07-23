//
//  Selectable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 03/01/2026.
//

import MatheRange

/// Component that can be selected through a selection.
/// 
/// A selection is a mask used to select state in a given context.
public protocol Selectable {
    /// Infinitesimal interval whose passage is instantaneous.
    typealias Instant = Selection.Bound
    /// Mask used to select state in a given context.
    /// 
    /// This represents the type of selection that can be used.
    associatedtype Selection: Boundary
    // MARK: Methods
    /// Checks whether a selection can select this item.
    /// - Parameter selection: Selection to be performed.
    /// 
    /// Example:
    /// ```swift
    /// SelectableInt(6).canBeSelected(by: 4...9)
    /// ```
    func canBeSelected(by selection: Selection) -> Bool
}

// MARK: Sequence (EX)
public extension Sequence where Element: Selectable {
    /// Checks whether a selection can select one of the sequence's elements.
    /// - Parameter selection: Selection to be performed.
    func canBeSelected(by selection: Element.Selection) -> Bool {
        contains { $0.canBeSelected(by: selection) }
    }
    /// Obtains all elements that can be selected by the given selection.
    /// - Parameter selection: Selection to be used.
    /// - Returns: List of all elements in the selection.
    func selectAll(in selection: Element.Selection) -> [Element] {
        filter { $0.canBeSelected(by: selection) }
    }
}
