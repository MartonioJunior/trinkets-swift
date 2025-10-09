//
//  TrinketRegistry+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import SM64Trinkets
import Testing

struct TrinketRegistryTests {
    typealias Mock = TrinketRegistry<Element>
    typealias Element = TrinketTests.Mock

    @Test("Creates a new registry from a sequence of entries", arguments: [
        ([Element("spike"), Element("Obstacle")], ["spike": Element("spike"), "Obstacle": Element("Obstacle")])
    ])
    func initializer(_ elements: [TrinketTests.Mock], expected: [Element.ID: Element]) {
        let result = TrinketRegistry<Element>(elements)
        #expect(result.contents == expected)
    }

    @Test("Returns all registered values", arguments: [
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), [Element("spike"), Element("Obstacle")])
    ])
    func entries(_ sut: Mock, expected: [Element]) {
        let result = sut.entries
        #expect(expected.contains(result))
    }

    @Test("Returns entry for a given ID", arguments: [
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), "spike", Element("spike")),
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), "apple", Element?.none)
    ])
    func `subscript`(_ sut: Mock, id: Element.ID, expected: Element?) {
        let result = sut[id: id]
        #expect(result == expected)
    }

    @Test("Returns entry for a ID string", arguments: [
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), "spike", Element("spike")),
        (Mock(arrayLiteral: Element("spike"), Element("Obstacle")), "apple", Element?.none)
    ])
    func `subscript`(_ sut: Mock, dynamicMember member: String, expected: Element?) {
        let result = sut[dynamicMember: member]
        #expect(result == expected)
    }

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
        let result = sut.register(entry)
        #expect(result == expected)
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
        sut.removeEntry(by: id)
        #expect(sut == expected)
    }

    // MARK: Self: ExpressibleByArrayLiteral
    struct ConformsToExpressibleByArrayLiteral {
        @Test("Creates a registry from an array")
        func initializer() {
            let caseA = Mock(arrayLiteral: Element("point"), Element("ham"))
            #expect(caseA == Mock([Element("point"), Element("ham")]))
        }
    }

    // MARK: Self.Entry: CaseIterable
    struct EntryIsCaseIterable {
        @Test("Returns a registry with all cases")
        func allEntries() {
            let result = TrinketRegistry<SM64Cap>.allEntries
            let expected = TrinketRegistry(SM64Cap.allCases)
            #expect(result == expected)
        }
    }
}
