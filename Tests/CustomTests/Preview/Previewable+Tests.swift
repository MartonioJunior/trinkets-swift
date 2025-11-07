//
//  Previewable+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/11/2025.
//

@testable import Custom
import Testing

struct PreviewableTests {
    struct Mock: Previewable, Equatable {
        var value: Int

        init(_ value: Int) {
            self.value = value
        }
    }

    @Test("Creates a new preview with the given modifiers", arguments: [
        (Mock(22), [MockModifier(Mock(14)), MockModifier(Mock(9))], Mock(9)),
        (Mock(10), [MockModifier<Mock>](), Mock(10))
    ])
    func preview(_ sut: Mock, _ modifiers: [MockModifier<Mock>], expected: Mock) {
        let value = sut.preview(modifiers)
        #expect(value == expected)
    }
}
