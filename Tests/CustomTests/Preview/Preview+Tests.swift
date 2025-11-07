//
//  Preview+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/11/2025.
//

@testable import Custom
import Testing

struct PreviewTests {
    typealias Mock = Preview<String, Int>

    @Test("Creates a new preview", arguments: [
        (6, true)
    ])
    func initializer(_ target: Int, output: Bool) {
        let sut = Preview(target, output: output)
        #expect(sut.target == target)
        #expect(sut.output == output)
    }

    // MARK: Modifier (EX)
    struct ModifierTests {
        typealias Mock = MockModifier<Int>

        @Test("Applies to a target based on predicate", arguments: [
            (Mock(32), 8, true, 32, true),
            (Mock(32), 8, false, 8, nil)
        ])
        func apply(_ sut: Mock, to target: Int, predicate: Bool, expected: Int, result: Bool?) {
            var target = target
            sut.apply(to: &target) { _ in predicate }
            #expect(target == expected)
        }

        @Test("Shows a preview for a target", arguments: [
            (Mock(21), 8, Preview(21, output: ()))
        ])
        func preview(_ sut: Mock, on source: Int, expected: PreviewFor<Mock>) {
            let result = sut.preview(on: source)
            #expect(result.target == expected.target)
            #expect(result.output == expected.output)
        }

        @Test("Shows a preview of a sequence of modifiers in a target", arguments: [
            ([Mock(4), Mock(8)], 14, 8)
        ])
        func preview(_ sut: [Mock], on target: Int, expected: Int) {
            let result = sut.preview(on: target)
            #expect(result == expected)
        }
    }
}
