//
//  SelectionGroup+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 23/07/2026.
//

@testable import Flow
import Testing

struct SelectionGroupTests {
    typealias Mock = SelectionGroup<[BoundaryOfOne<Int>]>
    typealias Item = SelectableTests.Mock

    @Test("Creates a new selection group", arguments: [
        ([BoundaryOfOne<Int>(1), BoundaryOfOne<Int>(2)])
    ])
    func initializer(_ selections: [BoundaryOfOne<Int>]) {
        let sut = SelectionGroup(selections)
        #expect(sut.selections == selections)
    }

    @Test("Selects elements from a sequence of selectable values", arguments: [
        (
            SelectionGroup<[ClosedRange<Int>]>([1...2, 6...7]),
            [Item(id: 1), Item(id: 3), Item(id: 4)],
            [Item(id: 1)]
        ),
        (
            SelectionGroup<[ClosedRange<Int>]>([1...2, 6...7]),
            [Item(id: 1), Item(id: 2)],
            [Item(id: 1), Item(id: 2)]
        ),
        (
            SelectionGroup<[ClosedRange<Int>]>([1...2, 6...7]),
            [Item(id: 5), Item(id: 8)],
            [Item]()
        )
    ])
    func select(_ sut: SelectionGroup<[ClosedRange<Int>]>, from sequence: [Item], expected: [Item]) {
        let result = sut.select(from: sequence)
        #expect(result == expected)
    }
}

extension SelectionGroupTests {
    // MARK: Self: Boundary
    struct ConformsToBoundary {
        @Test("Checks when element is part of selection", arguments: [
            (Mock([BoundaryOfOne<Int>(1), BoundaryOfOne<Int>(2)]), 1, true),
            (Mock([BoundaryOfOne<Int>(1), BoundaryOfOne<Int>(2)]), 3, false)
        ])
        func contains(lhs: Mock, rhs: Int, expected: Bool) {
            let result = lhs ~= rhs
            #expect(result == expected)
        }
    }

    // MARK: Sequence (EX)
    struct SequenceTests {
        @Test("Selects elements in a collection", arguments: [
            (
            [Item(id: 1), Item(id: 3), Item(id: 4)],
            SelectionGroup<[ClosedRange<Int>]>([1...2, 6...7]),
            [Item(id: 1)]
        ),
        (
            [Item(id: 1), Item(id: 2)],
            SelectionGroup<[ClosedRange<Int>]>([1...2, 6...7]),
            [Item(id: 1), Item(id: 2)]
        ),
        (
            [Item(id: 5), Item(id: 8)],
            SelectionGroup<[ClosedRange<Int>]>([1...2, 6...7]),
            [Item]()
        )
        ])
        func selectAll(_ sut: [Item], using selector: SelectionGroup<[ClosedRange<Int>]>, expected: [Item]) {
            let result = sut.selectAll(using: selector)
            #expect(result == expected)
        }
    }
}
