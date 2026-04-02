//
//  IdentifiedArray+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import IdentifiedCollections
import Testing

struct IdentifiedArrayTests {
    typealias Mock = IdentifiedArrayOf<Element>
    typealias Element = TrinketTests.Mock

    @Test("Returns entry for key", arguments: [
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), Element.Key("spike"), Element("spike")),
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), Element.Key("apple"), Element?.none)
    ])
    func `subscript`(_ sut: Mock, key: Element.Key, expected: Element?) {
        let result = sut[key]
        #expect(result == expected)
    }

    @Test("Adds a new entry to the registry", arguments: [
        (
            Mock(arrayLiteral: Element("spike"), Element("Obstacle")), Element("apple"),
            true, Mock(arrayLiteral: Element("spike"), Element("Obstacle"), Element("apple"))
        ),
        (
            Mock(arrayLiteral: Element("spike"), Element("Obstacle")), Element("spike"),
            false, Mock(arrayLiteral: Element("spike"), Element("Obstacle"))
        )
    ])
    func register(_ sut: Mock, _ entry: Element, expected: Bool, newState: Mock) {
        var sut = sut
        let result = sut.append(entry)
        #expect(result.inserted == expected)
        #expect(sut == newState)
    }

    @Test("Adds a new entry to the registry", arguments: [
        (
            Mock(arrayLiteral: Element("spike"), Element("Obstacle")), "apple",
            Mock(arrayLiteral: Element("spike"), Element("Obstacle"))
        ),
        (
            Mock(arrayLiteral: Element("spike"), Element("Obstacle")), "spike",
            Mock(arrayLiteral: Element("Obstacle"))
        )
    ])
    func removeEntry(_ sut: Mock, by id: Element.ID, expected: Mock) {
        var sut = sut
        sut.remove(id: id)
        #expect(sut == expected)
    }
}
