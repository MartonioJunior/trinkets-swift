//
//  IndexMap+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/09/2026.
//

import CustomDump
@testable import Flow
import Testing

struct IndexMapTests {
    @Test("Creates a new index map", arguments: [
        ([2: "goal"], "apple", map: [IndexMap<String, Int>.Entry(9, to: 2)])
    ])
    func initializer(_ elements: [Int: String], fallback: String, map: [IndexMap<String, Int>.Entry]) {
        let sut = IndexMap<String, Int>(elements, fallback: fallback, map: map)
        #expect(sut.elements == elements)
        #expect(sut.fallback == fallback)
        #expect(sut.map == map)
    }

    // MARK: Methods
    @Test("Removes connections without removing values")
    func clear() {
        var connectionExists = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )

        expectDifference(connectionExists) {
            connectionExists.clear(9)
        } changes: {
            $0.map = []
        }

        let noConnection = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(5, to: 3)]
        )

        expectNoChanges(noConnection) {
            $0.clear(9)
        }
    }

    @Test("Creates a new connection")
    func connect() {
        var newConnection = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        expectDifference(newConnection) {
            newConnection.connect(12, index: 4)
        } changes: {
            $0.map = [
                IndexMap<String, Int>.Entry(9, to: 2),
                IndexMap<String, Int>.Entry(12, to: 4)
            ]
        }

        var existingConnection = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        expectDifference(existingConnection) {
            existingConnection.connect(9, index: 4)
        } changes: {
            $0.map = [
                IndexMap<String, Int>.Entry(9, to: 4)
            ]
        }
    }

    @Test("Fetches section for a given instant")
    func entry() {
        let sut = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        let someValue = IndexMap<String, Int>.Entry(9, to: 2)
        let valueAtCutoff = sut.entry(for: 9)
        #expect(valueAtCutoff == someValue)

        let valueInBoundary = sut.entry(for: 14)
        #expect(valueInBoundary == someValue)

        let valueOutOfRange = sut.entry(for: 6)
        #expect(valueOutOfRange == Optional<IndexMap<String, Int>.Entry>.none)
    }

    @Test("Adds element to index map")
    func register() {
        var newElement = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        expectDifference(newElement) {
            newElement.register("wall", at: 6)
        } changes: {
            $0.elements = [
                2: "goal",
                6: "wall"
            ]
        }

        var existingElement = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        expectDifference(existingElement) {
            existingElement.register("wall", at: 2)
        } changes: {
            $0.elements = [
                2: "wall"
            ]
        }
    }

    @Test("Removes element from the index map")
    func removeElement() {
        var withoutClearingMap = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        expectDifference(withoutClearingMap) {
            withoutClearingMap.removeElement(at: 2, clearMap: false)
        } changes: {
            $0.elements = [:]
        }

        var clearingMap = IndexMap<String, Int>(
            [2: "goal"],
            fallback: "bloke",
            map: [IndexMap<String, Int>.Entry(9, to: 2)]
        )
        expectDifference(clearingMap) {
            clearingMap.removeElement(at: 2, clearMap: true)
        } changes: {
            $0.elements = [:]
            $0.map = []
        }
    }

    // MARK: DotSyntax
    @Test("Creates index map with one value and no connections", arguments: [
        ("goal", IndexMap<String, Int>([:], fallback: "goal", map: []))
    ])
    func ofOne(_ element: String, expected: IndexMap<String, Int>) {
        let result = IndexMap.ofOne(element, Int.self)
        #expect(result == expected)
    }
}

// MARK: Self.Entry
struct IndexMapEntryTests {
    @Test("Creates a new entry", arguments: [
        ("goal", 12)
    ])
    func initializer(_ instant: String, to index: Int?) {
        let sut = IndexMap<String, String>.Entry(instant, to: index)
        #expect(sut.instant == instant)
        #expect(sut.index == index)
    }

    struct ComparableTests {
        @Test("Ordered based on instant", arguments: [
            (
                IndexMap<String, String>.Entry("goal", to: 4),
                IndexMap<String, String>.Entry("ball", to: 8),
                false
            ),
            (
                IndexMap<String, String>.Entry("element", to: 4),
                IndexMap<String, String>.Entry("element", to: 8),
                false
            ),
            (
                IndexMap<String, String>.Entry("element", to: 4),
                IndexMap<String, String>.Entry("tail", to: 8),
                true
            )
        ])
        func lesserThan(
            lhs: IndexMap<String, String>.Entry,
            rhs: IndexMap<String, String>.Entry,
            expected: Bool
        ) {
            let result = lhs < rhs
            #expect(result == expected)
        }
    }
}

extension IndexMapTests {
    // MARK: Self: Boundary
    struct ConformsToBoundary {
        @Test("Boundary validated based on entries", arguments: [
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                ), 9, true
            ),
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                ), 13, true
            ),
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                ), 3, false
            ),
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: []
                ), 13, false
            )
        ])
        func contains(lhs: IndexMap<String, Int>, rhs: Int, expected: Bool) {
            let result = lhs ~= rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: Block
    struct ConformsToBlock {
        @Test("Mask is itself", arguments: [
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                )
            )
        ])
        func mask(_ sut: IndexMap<String, Int>) {
            #expect(sut.mask == sut)
        }

        @Test("Obtains element for a given instant", arguments: [
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                ), 9, "goal"
            ),
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                ), 14, "goal"
            ),
            (
                IndexMap<String, Int>(
                    [2: "goal"],
                    fallback: "bloke",
                    map: [IndexMap<String, Int>.Entry(9, to: 2)]
                ), 1, "bloke"
            )
        ])
        func element(_ sut: IndexMap<String, Int>, on instant: Int, expected: String) {
            let result = sut.element(on: instant)
            #expect(result == expected)
        }
    }

    // MARK: Self.Element: Optional
    struct ElementConformsToOptional {
        @Test("Creates index map without fallback", arguments: [
            ([2: "goal"], [IndexMap<String?, Int>.Entry(9, to: 4)])
        ])
        func initializer(_ elements: [Int: String], map: [IndexMap<String?, Int>.Entry]) {
            let sut = IndexMap<String?, Int>(elements, map: map)
            #expect(sut.elements == elements)
            #expect(sut.map == map)
            #expect(sut.fallback == nil)
        }
    }
}
