//
//  Trinket+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import Testing

struct TrinketTests {
    // MARK: Mock
    struct Mock: Trinket, Equatable {
        typealias Value = Double

        var id: String

        init(_ id: String) {
            self.id = id
        }
    }

    struct AlternativeMock: Trinket, Equatable {
        typealias Value = Double

        var id: String

        init(_ id: String) {
            self.id = id
        }
    }

    // MARK: Default Implementation
    @Test("Returns ID for type in Trinketpedia")
    func trinketpediaID() {
        let result = Mock.trinketpediaID
        let expected = "Mock"
        #expect(result == expected)
    }

    @Test("Creates a Measure", arguments: [
        (Mock("kol"), 24, Mock.Measure(value: 24, unit: Mock("kol")))
    ])
    func callAsFunction(_ sut: Mock, _ amount: Mock.Value, expected: Mock.Measure) {
        let result = sut(amount)
        #expect(result == expected)
    }
}

// MARK: Sequence (EX)
struct SequenceTests {
    typealias MockElement = TrinketTests.Mock
    typealias AlternativeElement = TrinketTests.AlternativeMock

    struct ElementisAnyTrinket {
        @Test("Performs a compact map to extract a trinket")
        func `subscript`() {
            let caseA: [any Trinket] = [MockElement("yes"), MockElement("go")]
            let expectedA = [MockElement("yes"), MockElement("go")]
            #expect(caseA[MockElement.self] == expectedA)

            let caseB: [any Trinket] = [MockElement("goal"), AlternativeElement("offside")]
            let expectedB1 = [AlternativeElement("offside")]
            let expectedB2 = [MockElement("goal")]
            #expect(caseB[AlternativeElement.self] == expectedB1)
            #expect(caseB[MockElement.self] == expectedB2)
        }
    }

    struct ElementConformsToTrinket {
        @Test("Returns trinkets with designated key", arguments: [
            ([MockElement("uask"), MockElement("graps")], TrinketKey<MockElement>("graps"), [MockElement("graps")]),
            (
                [MockElement("graps"), MockElement("uask"), MockElement("graps")],
                TrinketKey<MockElement>("graps"), [MockElement("graps"), MockElement("graps")]
            ),
            ([MockElement("uask"), MockElement("loipr")], TrinketKey<MockElement>("graps"), [])
        ])
        func `subscript`(_ sut: [MockElement], _ key: TrinketKey<MockElement>, expected: [MockElement]) {
            let result = sut[key]
            #expect(result == expected)
        }

        @Test("Returns trinkets with designated ID", arguments: [
            ([MockElement("uask"), MockElement("graps")], "graps", [MockElement("graps")]),
            (
                [MockElement("graps"), MockElement("uask"), MockElement("graps")],
                "graps", [MockElement("graps"), MockElement("graps")]
            ),
            ([MockElement("uask"), MockElement("loipr")], "graps", [])
        ])
        func `subscript`(_ sut: [MockElement], id: MockElement.ID, expected: [MockElement]) {
            let result = sut[id: id]
            #expect(result == expected)
        }

        @Test("Returns trinkets based on instance comparation", arguments: [
            ([MockElement("uask"), MockElement("graps")], MockElement("graps"), [MockElement("graps")]),
            (
                [MockElement("graps"), MockElement("uask"), MockElement("graps")],
                MockElement("graps"), [MockElement("graps"), MockElement("graps")]
            ),
            ([MockElement("uask"), MockElement("loipr")], MockElement("graps"), [])
        ])
        func `subscript`(_ sut: [MockElement], _ item: MockElement, expected: [MockElement]) {
            let result = sut[item]
            #expect(result == expected)
        }
    }
}

// MARK: Unit (EX)
import TrinketsUnits

extension UnitTests {
    @Test("Returns Trinket ID", arguments: [
        (Unit<TrinketTests.Mock>("op", details: TrinketTests.Mock("glip")), "glip")
    ])
    func id(_ sut: Unit<TrinketTests.Mock>, expected: TrinketTests.Mock.ID) {
        let result = sut.id
        #expect(result == expected)
    }

    @Test("Creates new unit based on trinket", arguments: [
        (TrinketTests.Mock("ya"), Unit<TrinketTests.Mock>("ya", details: TrinketTests.Mock("ya")))
    ])
    func trinket(_ data: TrinketTests.Mock, expected: Unit<TrinketTests.Mock>) {
        let result = Unit.trinket(data)
        #expect(result == expected)
    }

    @Test("Creates new unit based on trinket", arguments: [
        (TrinketTests.Mock("ya"), "dud", Unit<TrinketTests.Mock>("dud", details: TrinketTests.Mock("ya")))
    ])
    func trinket(_ data: TrinketTests.Mock, _ symbol: TrinketTests.Mock.Symbol, expected: Unit<TrinketTests.Mock>) {
        let result = Unit.trinket(data, symbol: symbol)
        #expect(result == expected)
    }
}
