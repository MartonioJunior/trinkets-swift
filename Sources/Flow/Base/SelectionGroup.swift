//
//  SelectionGroup.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2026.
//

import MatheRange
/// Short-hand alias for a list of boundaries combined into a single selection.
public typealias SelectionGroupOf<Element: Boundary> = SelectionGroup<[Element]>
/// Wrapper that combines a collection of boundaries into a single selection.
public struct SelectionGroup<Selections: Collection> where Selections.Element: Boundary {
    // MARK: Variables
    /// Collection of boundaries.
    var selections: Selections
    // MARK: Initializers
    /// Creates a new selector.
    /// - Parameter selections: Collection of boundaries representing the selection.
    public init(_ selections: Selections) {
        self.selections = selections
    }
    // MARK: Methods
    /// Selects elements from a given sequence.
    /// - Parameter sequence: Sequence of selectable elements.
    /// - Returns: List of selected elements.
    public func select<S: Sequence>(
        from sequence: S
    ) -> [S.Element] where S.Element: Selectable, S.Element.Selection == Selections.Element {
        sequence.filter { element in
            selections.contains { selection in
                element.canBeSelected(by: selection)
            }
        }
    }
}

// MARK: Self: Boundary
extension SelectionGroup: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = Selections.Element.Bound
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Bound) -> Bool {
        lhs.selections.contains { $0.contains(rhs) }
    }
}

// MARK: Self: Equatable
extension SelectionGroup: Equatable where Selections: Equatable {}

// MARK: Self: Sendable
extension SelectionGroup: Sendable where Selections: Sendable {}

// MARK: Sequence (EX)
public extension Sequence where Element: Selectable {
    /// Selects elements from this sequence using a selector.
    /// - Parameter selector: Selector.
    /// - Returns: List of selected elements.
    func selectAll<C: Collection>(
        using selector: SelectionGroup<C>
    ) -> [Element] where C.Element == Element.Selection {
        selector.select(from: self)
    }
}
