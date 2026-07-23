//
//  Selectable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 23/07/2026.
//

@testable import Flow
import Testing

struct SelectableTests {
    struct Mock: Selectable, Equatable {
        var id: Int

        func canBeSelected(by selection: ClosedRange<Int>) -> Bool {
            selection.contains(id)
        }
    }
    // MARK: Sequence (EX)
    @Test("Checks whether the element in a sequence can be selected", arguments: [
        ([Mock(id: 6), Mock(id: 8), Mock(id: 12)], 1...10, true),
        ([Mock(id: 6), Mock(id: 8), Mock(id: 12)], 20...30, false),
        ([Mock](), 20...30, false)
    ])
    func canBeSelected(_ sut: [Mock], by selection: ClosedRange<Int>, expected: Bool) {
        let result = sut.canBeSelected(by: selection)
        #expect(result == expected)
    }

    @Test("Checks whether the element in a sequence can be selected", arguments: [
        ([Mock(id: 6), Mock(id: 8), Mock(id: 12)], 1...10, [Mock(id: 6), Mock(id: 8)]),
        ([Mock(id: 6), Mock(id: 8), Mock(id: 12)], 20...30, [Mock]()),
        ([Mock](), 20...30, [Mock]())
    ])
    func selectAll(_ sut: [Mock], in selection: ClosedRange<Int>, expected: [Mock]) {
        let result = sut.selectAll(in: selection)
        #expect(result == expected)
    }
}
