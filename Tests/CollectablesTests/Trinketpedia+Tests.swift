//
//  Trinketpedia+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

@testable import Collectables
import SM64Trinkets
import Testing

// MARK: Mock
public extension Trinketpedia {
    static var sm64: Trinketpedia {
        var result = Trinketpedia()
        result[SM64Cap.self] = .allEntries
        result[SM64Star.self] = []
        result[SM64Currency.self] = .allEntries
        result[SM64Location.self] = []
        result[SM64KeyItem.self] = []
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
        let resultA = sut[SM64Cap.self]
        let expectedA = SM64Cap.Registry()
        #expect(resultA == expectedA)

        sut[SM64Cap.self] = [SM64Cap.metal, .vanish]
        let resultB1 = sut[SM64Cap.self]
        let resultB2 = sut[SM64Currency.self]
        let expectedB1: Trinketpedia.Registry = [SM64Cap.vanish, .metal]
        let expectedB2 = SM64Currency.Registry()
        #expect(resultB1 == expectedB1)
        #expect(resultB2 == expectedB2)
    }

    @Test("Retrieves a registered trinket", arguments: [
        (Trinketpedia(), SM64Cap.wing.id, SM64Cap?.none),
        (Trinketpedia.sm64, SM64Cap.vanish.id, SM64Cap.vanish),
        (Trinketpedia.sm64, "Tanooki", SM64Cap?.none)
    ])
    func `subscript`(_ sut: Trinketpedia, id: SM64Cap.ID, expected: SM64Cap?) {
        let result = sut[SM64Cap.self, id: id]
        #expect(result == expected)
    }

    @Test("Retrieves a registered trinket", arguments: [
        (Trinketpedia(), "wingCap", SM64Cap?.none),
        (Trinketpedia.sm64, "vanishCap", SM64Cap.vanish),
        (Trinketpedia.sm64, "Tanooki", SM64Cap?.none)
    ])
    func `subscript`(_ sut: Trinketpedia, dynamicMember member: String, expected: SM64Cap?) {
        let result: SM64Cap? = sut[dynamicMember: member]
        #expect(result == expected)
    }

    @Test("Returns a Trinket by it's ID", arguments: [
        (Trinketpedia(), SM64Cap.wing.id, SM64Cap?.none),
        (Trinketpedia.sm64, SM64Cap.vanish.id, SM64Cap.vanish),
        (Trinketpedia.sm64, "Tanooki", SM64Cap?.none)
    ])
    func fetch(_ sut: Trinketpedia, id: SM64Cap.ID, expected: SM64Cap?) {
        let result: SM64Cap? = sut.fetch(id: id)
        #expect(result == expected)
    }

    @Test("Adds new Trinkets to the data structure", arguments: [
        (Trinketpedia(), SM64Cap.Registry.allEntries, SM64Cap.Registry.allEntries),
        (Trinketpedia.sm64, SM64Cap.Registry.allEntries, SM64Cap.Registry.allEntries),
        (Trinketpedia.sm64, SM64Cap.Registry(), SM64Cap.Registry.allEntries),
        (Trinketpedia(), SM64Cap.Registry(), SM64Cap.Registry())
    ])
    func register(_ sut: Trinketpedia, _ database: SM64Cap.Registry, expected: SM64Cap.Registry) {
        var sut = sut
        sut.register(SM64Cap.self, database)
        #expect(sut[SM64Cap.self] == expected)
    }

    @Test("Deletes a database from the data structure", arguments: [
        (Trinketpedia(), true, SM64Cap.Registry(), SM64Currency.Registry()),
        (Trinketpedia(), false, SM64Cap.Registry(), SM64Currency.Registry()),
        (Trinketpedia.sm64, true, SM64Cap.Registry.allEntries, SM64Currency.Registry()),
        (Trinketpedia.sm64, false, SM64Cap.Registry(), SM64Currency.Registry.allEntries)
    ])
    func removeDatabase(
        _ sut: Trinketpedia,
        currencyOverCaps: Bool,
        expectedCaps: SM64Cap.Registry,
        expectedCurrency: SM64Currency.Registry
    ) {
        var sut = sut

        if currencyOverCaps {
            sut.removeDatabase(SM64Currency.self)
        } else {
            sut.removeDatabase(SM64Cap.self)
        }

        #expect(sut[SM64Currency.self] == expectedCurrency)
        #expect(sut[SM64Cap.self] == expectedCaps)
    }

    @Test("Clears the entire data structure", arguments: [
        (Trinketpedia()),
        (Trinketpedia.sm64)
    ])
    func removeAll(_ sut: Trinketpedia) {
        var sut = sut
        sut.removeAll()

        #expect(sut[SM64Currency.self] == SM64Currency.Registry())
        #expect(sut[SM64Cap.self] == SM64Cap.Registry())
    }

    @Test("Defines multiple ways to access a trinket")
    func syntax() {
        let trinketpedia = Trinketpedia()
        let metalBlockKey = SM64KeyItem.block(.metal).key
        let metalBlock = trinketpedia[metalBlockKey]
        let bowserInTheSky: SM64Location.Key = "bowserInTheSky"
        let capA: SM64Cap? = trinketpedia.fetch(id: "wingCap")
        let capB: SM64Cap? = trinketpedia[id: "wingCap"]
        let capC: SM64Cap? = trinketpedia.wingCap
        let star = trinketpedia[SM64Star.self].toad0
        let location = trinketpedia[SM64Location.self, id: "bowserSky"]
    }
}
