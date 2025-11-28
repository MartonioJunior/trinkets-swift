//
//  IdentifiedArray+Collectables.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/11/2025.
//

import IdentifiedCollections

public extension IdentifiedArray where Element: Identifiable, Element: CaseIterable, ID == Element.ID {
    static var allCases: Self { .init(Element.allCases) { a, _ in a } }
}

// MARK: Trinket (EX)
public extension Trinket {
    typealias Registry = IdentifiedArrayOf<Self>
}
