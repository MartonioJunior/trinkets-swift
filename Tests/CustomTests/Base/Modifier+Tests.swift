//
//  Modifier+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/11/2025.
//

@testable import Custom
import Testing

struct ModifierTests {
    typealias Mock = MockModifier<Int>

    @Test("Creates an alternative that uses an Optional and returns no output", arguments: [
        (Mock(73), 12, 73)
    ])
    func forSlot(_ sut: Mock, input: Int, expected: Int) {
        var testValue = input
        var optionalTestValue: Int? = input

        sut.apply(to: &testValue)
        sut.forSlot.apply(to: &optionalTestValue)

        #expect(testValue == expected)
        #expect(optionalTestValue == expected)
    }

    @Test("Transforms the modifier so it doesn't return an output", arguments: [
        (Mock(73), 12, 73)
    ])
    func noOutput(_ sut: Mock, input: Int, expected: Int) {
        var testValue = input
        var optionalTestValue = input

        sut.apply(to: &testValue)
        sut.noOutput.apply(to: &optionalTestValue)

        #expect(testValue == expected)
        #expect(optionalTestValue == expected)
    }

    @Test("Transforms the modifier to be used on Optional targets", arguments: [
        (Mock(73), 12, 73)
    ])
    func optional(_ sut: Mock, input: Int, expected: Int) {
        var testValue = input
        var optionalTestValue: Int? = input

        sut.apply(to: &testValue)
        let nonNilOutput = sut.optional.apply(to: &optionalTestValue)

        #expect(testValue == expected)
        #expect(optionalTestValue == expected)
        #expect(nonNilOutput != nil)

        optionalTestValue = nil
        let nilOutput = sut.optional.apply(to: &optionalTestValue)

        #expect(optionalTestValue == nil)
        #expect(nilOutput == nil)
    }
}

// MARK: Sequence (EX)
struct SequenceTests {
    @Test("Applies all modifiers to target", arguments: [
        (4, 5)
    ])
    func apply(to target: Int, expected: Int) {
        var target = target
        let modifiers = [
            Modify<Int, Void> { $0 *= 2 },
            Modify<Int, Void> { $0 -= 3 }
        ]
        modifiers.apply(to: &target)
        #expect(target == expected)
    }
}
