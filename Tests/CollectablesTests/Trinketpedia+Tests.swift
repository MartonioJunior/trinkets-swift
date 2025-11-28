//
//  Trinketpedia+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

@testable import Collectables
import Testing

// MARK: Mock
public extension Trinketpedia {
    static var example: Trinketpedia {
        var result = Trinketpedia()
        result[MockMaterial.self] = .allEntries
        result[MockItem.self] = []
        result[MockCurrency.self] = .allEntries
        result[MockAccessory.self] = []
        result[MockTicket.self] = []
        return result
    }
}

struct TrinketpediaTests {
    @Test("Creates a new Trinketpedia instance")
    func initializer() {
        let result = Trinketpedia()
        let expectedDatabases: [String: Any] = [:]
        #expect(result.databases.keys == expectedDatabases.keys)
    }

    @Test("Returns the database for a registered type")
    func `subscript`() {
        var sut = Trinketpedia()
        let resultA = sut[MockMaterial.self]
        let expectedA = MockMaterial.Registry()
        #expect(resultA == expectedA)

        sut[MockMaterial.self] = ["lollipop", "cylinder"]
        let resultB1 = sut[MockMaterial.self]
        let resultB2 = sut[MockTicket.self]
        let expectedB1: Trinketpedia.Registry<MockMaterial> = ["lollipop", "cylinder"]
        let expectedB2 = MockTicket.Registry()
        #expect(resultB1 == expectedB1)
        #expect(resultB2 == expectedB2)
    }

    @Test("Retrieves a registered trinket", arguments: [
        (Trinketpedia(), MockCurrency.coin.id, MockCurrency?.none),
        (Trinketpedia.example, MockCurrency.feather.id, MockCurrency.feather),
        (Trinketpedia.example, "Tanooki", MockCurrency?.none)
    ])
    func `subscript`(_ sut: Trinketpedia, id: MockCurrency.ID, expected: MockCurrency?) {
        let result = sut[MockCurrency.self, id: id]
        #expect(result == expected)
    }

    @Test("Retrieves a registered trinket", arguments: [
        (Trinketpedia(), "coin", MockCurrency?.none),
        (Trinketpedia.example, "ticket", MockCurrency.ticket),
        (Trinketpedia.example, "Tanooki", MockCurrency?.none)
    ])
    func `subscript`(_ sut: Trinketpedia, dynamicMember member: String, expected: MockCurrency?) {
        let result: MockCurrency? = sut[dynamicMember: member]
        #expect(result == expected)
    }

    @Test("Returns a Trinket by it's ID", arguments: [
        (Trinketpedia(), MockCurrency.ticket.id, MockCurrency?.none),
        (Trinketpedia.example, MockCurrency.feather.id, MockCurrency.feather),
        (Trinketpedia.example, "Tanooki", MockCurrency?.none)
    ])
    func fetch(_ sut: Trinketpedia, id: MockCurrency.ID, expected: MockCurrency?) {
        let result: MockCurrency? = sut.fetch(id: id)
        #expect(result == expected)
    }

    @Test("Adds new Trinkets to the data structure", arguments: [
        (Trinketpedia(), MockCurrency.Registry.allEntries, MockCurrency.Registry.allEntries),
        (Trinketpedia.example, MockCurrency.Registry.allEntries, MockCurrency.Registry.allEntries),
        (Trinketpedia.example, MockCurrency.Registry(), MockCurrency.Registry.allEntries),
        (Trinketpedia(), MockCurrency.Registry(), MockCurrency.Registry())
    ])
    func register(_ sut: Trinketpedia, _ database: MockCurrency.Registry, expected: MockCurrency.Registry) {
        var sut = sut
        sut.register(MockCurrency.self, database)
        #expect(sut[MockCurrency.self] == expected)
    }

    @Test("Deletes a database from the data structure", arguments: [
        (Trinketpedia(), true, MockCurrency.Registry(), MockMaterial.Registry()),
        (Trinketpedia(), false, MockCurrency.Registry(), MockMaterial.Registry()),
        (Trinketpedia.example, true, MockCurrency.Registry.allEntries, MockMaterial.Registry()),
        (Trinketpedia.example, false, MockCurrency.Registry(), MockMaterial.Registry.allEntries)
    ])
    func removeDatabase(
        _ sut: Trinketpedia,
        currencyOverCaps: Bool,
        expectedCaps: MockCurrency.Registry,
        expectedCurrency: MockMaterial.Registry
    ) {
        var sut = sut

        if currencyOverCaps {
            sut.removeDatabase(MockMaterial.self)
        } else {
            sut.removeDatabase(MockCurrency.self)
        }

        #expect(sut[MockMaterial.self] == expectedCurrency)
        #expect(sut[MockCurrency.self] == expectedCaps)
    }

    @Test("Clears the entire data structure", arguments: [
        (Trinketpedia()),
        (Trinketpedia.example)
    ])
    func removeAll(_ sut: Trinketpedia) {
        var sut = sut
        sut.removeAll()

        #expect(sut[MockMaterial.self] == MockMaterial.Registry())
        #expect(sut[MockCurrency.self] == MockCurrency.Registry())
    }

    @Test("Defines multiple ways to access a trinket")
    func syntax() {
        let trinketpedia = Trinketpedia()
        let coinKey = MockAccessory("metalBlock").key
        let metalBlock = trinketpedia[coinKey]
        let ringKey: MockItem.Key = "ring"
        let materialA: MockMaterial? = trinketpedia.fetch(id: "wingFeather")
        let materialB: MockMaterial? = trinketpedia[id: "wingFeather"]
        let materialC: MockMaterial? = trinketpedia.wingFeather
        let dynamicFromKey = trinketpedia[MockAccessory.Key.lostAnkle]
        let dynamicFromRegistry = trinketpedia[MockMaterial.self].wing
        let location = trinketpedia[MockTicket.self, id: 10]
    }
}
