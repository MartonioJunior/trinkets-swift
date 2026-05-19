//
//  IdentifiedArray+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections
import SwiftVariety

public extension IdentifiedArray where Element: Identifiable, Element: CaseIterable, ID == Element.ID {
    /// Identified array with all registered cases for an enum or similar structure.
    static var allCases: Self { .init(Element.allCases) { a, _ in a } }
}

// MARK: Trinket (EX)
public extension Trinket {
    /// Registry used to store trinket entries that are uniquely identified.
    typealias Registry = IdentifiedArrayOf<Self>
    /// Key used to access a trinket registry in an heterogeneous collection.
    static var registryKey: HeterogeneousKey<String, Registry> { .init(trinketpediaID) }
}
