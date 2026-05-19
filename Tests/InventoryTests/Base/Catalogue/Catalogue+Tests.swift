//
//  Catalogue+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

@testable import Inventory
import Testing
import TrinketsUnits

public struct CatalogueTests {
    // MARK: Mocks
    struct Mock: Catalogue, Sendable, Dispenser {
        typealias Item = MockItem

        var fetchCallback: @Sendable ((Measurement<MockItem, Tally>) -> Any?) -> [Any]
        var hasCallback: @Sendable (Measurement<MockItem, Tally>) -> Bool

        func fetch<T>(_ transform: (Measurement<MockItem, Tally>) -> T?) -> [T] {
            fetchCallback(transform).compactMap { $0 as? T }
        }

        func has(_ content: Measurement<MockItem, Tally>) -> Bool {
            hasCallback(content)
        }

        static func numbers(_ items: Tally...) -> Self {
            return .init() { transform in
                items.compactMap { transform(measure($0)) }
            } hasCallback: { item in
                items.contains { measure($0).canSupply(item) }
            }
        }

        mutating func release(_ content: Measurement<MockItem, Tally>) -> Measurement<MockItem, Tally>? {
            content
        }
    }

    // MARK: Test Utilities
    static func measure(_ tally: Tally) -> Measurement<MockItem, Tally> {
        MockItem.number(Int(bitPattern: tally.amount)).x(tally)
    }

    static func greaterThan(_ other: Tally) -> @Sendable (Measurement<MockItem, Tally>) -> Bool {
        { other < $0.value }
    }

    static func always<T>(_ value: Bool) -> @Sendable (T) -> Bool {
        { _ in value }
    }

    static func optional<T>(_ value: Bool) -> @Sendable (T) -> T? {
        { value ? $0 : nil }
    }

    static func endsWith(_ value: String) -> @Sendable (MockItem) -> MockItem? {
        { $0.id.hasSuffix(value) ? $0 : nil }
    }

    static func overlapMin() -> @Sendable (Measurement<MockItem, Tally>, Measurement<MockItem, Tally>) -> Measurement<MockItem, Tally>? {
        { $0.unit == $1.unit ? $0.unit.x(min($0.value, $1.value)) : nil }
    }

    static func compose(_ value: Bool) -> @Sendable ([Measurement<MockItem, Tally>]) -> Measurement<MockItem, Tally>? {
        { value ? $0.first : $0.last }
    }

    // MARK: Default Implementation
    @Test("Obtains measures by filtering them", arguments: [
        (Mock.numbers(3, 6, 4, 5), Self.greaterThan(4), [Self.measure(6), Self.measure(5)]),
        (Mock.numbers(8, 4, 6), Self.always(true), [Self.measure(8), Self.measure(4), Self.measure(6)]),
        (Mock.numbers(8, 4, 6), Self.always(false), [Measurement<MockItem, Tally>]())
    ])
    func fetch(
        _ sut: Mock,
        where predicate: @Sendable (Measurement<MockItem, Tally>) -> Bool,
        expected: [Measurement<MockItem, Tally>]
    ) {
        let result = sut.fetch(where: predicate)
        #expect(result == expected)
    }

    @Test("Obtains measures by filtering item units", arguments: [
        (Mock.numbers(3, 7, 17), Self.endsWith("7"), [Self.measure(7), Self.measure(17)]),
        (Mock.numbers(8, 4, 6), Self.optional(true), [Self.measure(8), Self.measure(4), Self.measure(6)]),
        (Mock.numbers(8, 4, 6), Self.optional(false), [Measurement<MockItem, Tally>]())
    ])
    func fetchByItem(
        _ sut: Mock,
        _ transform: @Sendable (MockItem) -> MockItem?,
        expected: [Measurement<MockItem, Tally>]
    ) {
        let result = sut.fetchByItem(transform)
        #expect(result == expected)
    }

    @Test("Check if inventory has supply for criteria", arguments: [
        (Mock.numbers(3, 7, 17), Tally(integerLiteral: 22), Self.endsWith("7"), true),
        (Mock.numbers(3, 7, 17), Tally(integerLiteral: 42), Self.endsWith("7"), false),
        (Mock.numbers(3, 7, 17), Tally.infinite, Self.optional(true), false),
        (Mock.numbers(3, 7, 17), Tally.nullify, Self.optional(true), false),
        (Mock.numbers(3, .infinite, 17), Tally.infinite, Self.optional(true), true),
        (Mock.numbers(3, .infinite, 17), Tally.infinite, Self.optional(false), false),
        (Mock.numbers(3, .nullify, 17), Tally.nullify, Self.endsWith("7"), false),
        (Mock.numbers(3, .nullify, 17), Tally.nullify, Self.optional(true), true),
        (Mock.numbers(3, .nullify, 17), Tally.nullify, Self.optional(false), false),
        (Mock.numbers(8, 4, 6), Tally(integerLiteral: 12), Self.optional(true), true),
        (Mock.numbers(8, 4, 6), Tally(integerLiteral: 24), Self.optional(true), false)
    ])
    func has(
        _ sut: Mock,
        _ tally: Tally,
        transform: @Sendable (MockItem) -> MockItem?,
        expected: Bool
    ) {
        let result = sut.has(tally, transform)
        #expect(result == expected)
    }

    @Test("Check if the inventory has the given contents", arguments: [
        (Mock.numbers(3, 4, 5), [Self.measure(3)], true),
        (Mock.numbers(3, 4, 5), [Self.measure(4), Self.measure(6)], false),
        (Mock.numbers(3, 4, 5), [MockItem.number(3).x(2)], true),
        (Mock.numbers(), [MockItem.number(3).x(.nullify)], false),
        (Mock.numbers(9, 4, 3), [Measurement<MockItem, Tally>](), true),
        (Mock.numbers(), [Measurement<MockItem, Tally>](), true)
    ])
    func has(_ sut: Mock, _ contents: [Measurement<MockItem, Tally>], expected: Bool) {
        let result = sut.has { contents }
        #expect(result == expected)
    }

    @Test("Returns overlap between catalogues", arguments: [
        (
            Mock.numbers(3, 4, 5), [Self.measure(5), Self.measure(6)],
            Self.compose(true),
            [Self.measure(5)]
        ),
        (
            Mock.numbers(3, 5, 4, 5, 6),
            [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            Self.compose(false),
            [Self.measure(5), MockItem.number(6).x(4)]
        ),
        (
            Mock.numbers(), [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            Self.compose(true),
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
            Self.compose(true),
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.numbers(), [Measurement<MockItem, Tally>](),
            Self.compose(true),
            [Measurement<MockItem, Tally>]()
        )
    ])
    func intersection(
        _ sut: Mock,
        with other: [Measurement<MockItem, Tally>],
        compose: @Sendable ([Measurement<MockItem, Tally>]) -> Measurement<MockItem, Tally>?,
        expected: [Measurement<MockItem, Tally>]
    ) {
        let result = sut.intersection(with: { other }, overlap: Self.overlapMin(), compose: compose)
        #expect(result == expected)
    }

    @Test("Returns overlap between catalogues using first composition", arguments: [
        (
            Mock.numbers(3, 4, 5), [Self.measure(5), Self.measure(6)],
            [Self.measure(5)]
        ),
        (
            Mock.numbers(3, 5, 4, 5, 6),
            [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            [Self.measure(5), MockItem.number(6).x(4)]
        ),
        (
            Mock.numbers(), [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.numbers(), [Measurement<MockItem, Tally>](),
            [Measurement<MockItem, Tally>]()
        )
    ])
    func intersection(
        _ sut: Mock,
        with other: [Measurement<MockItem, Tally>],
        expected: [Measurement<MockItem, Tally>]
    ) {
        let result = sut.intersection(with: { other }, overlap: Self.overlapMin())
        #expect(result == expected)
    }

    @Test("Returns the difference in contents from catalogue A to B", arguments: [
        (
            Mock.numbers(3, 4, 5), [Self.measure(5), Self.measure(6)],
            [Self.measure(3), Self.measure(4)]
        ),
        (
            Mock.numbers(3, 5, 4, 5, 6),
            [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            [Self.measure(3), Self.measure(5), Self.measure(4), Self.measure(5), Self.measure(6)]
        ),
        (
            Mock.numbers(), [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
            [Self.measure(3), Self.measure(4), Self.measure(5)]
        ),
        (
            Mock.numbers(), [Measurement<MockItem, Tally>](),
            [Measurement<MockItem, Tally>]()
        )
    ])
    func uniqueAgainst(
        _ sut: Mock,
        _ other: [Measurement<MockItem, Tally>],
        expected: [Measurement<MockItem, Tally>]
    ) {
        let criteria: (Measurement<MockItem, Tally>, Measurement<MockItem, Tally>) -> Bool = {
            $0 == $1
        }

        let result = sut.uniqueAgainst({ other }, check: criteria)
        #expect(result == expected)
    }

    @Test("Returns elements in catalogue A not in B", arguments: [
        (
            Mock.numbers(3, 4, 5), [Self.measure(5), Self.measure(6)],
            [Self.measure(3), Self.measure(4)]
        ),
        (
            Mock.numbers(3, 5, 4, 5, 6),
            [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            [Self.measure(3), Self.measure(4)]
        ),
        (
            Mock.numbers(), [MockItem.number(5).x(.infinite), MockItem.number(6).x(4)],
            [Measurement<MockItem, Tally>]()
        ),
        (
            Mock.numbers(3, 4, 5), [Measurement<MockItem, Tally>](),
            [Self.measure(3), Self.measure(4), Self.measure(5)]
        ),
        (
            Mock.numbers(), [Measurement<MockItem, Tally>](),
            [Measurement<MockItem, Tally>]()
        )
    ])
    func uniqueNotIn(
        _ sut: Mock,
        _ other: [Measurement<MockItem, Tally>],
        expected: [Measurement<MockItem, Tally>]
    ) {
        let criteria: (MockItem, MockItem) -> Bool = {
            $0 == $1
        }

        let result = sut.uniqueNotIn({ other }, equals: criteria)
        #expect(result == expected)
    }
}
