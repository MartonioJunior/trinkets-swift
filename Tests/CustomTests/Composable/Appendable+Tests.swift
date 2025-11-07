//
//  Appendable+Tests.swift
//  Core
//
//  Created by Martônio Júnior on 30/05/2025.
//

@testable import Custom
import Testing

internal struct AppendableTests {
    typealias Mock = MockComposable<Int, Int>

    @Test("Appends a value to the type", arguments: [
        (Mock.additive(), 5, 5),
        (Mock.additive(3), 4, 7)
    ])
    func appending(_ sut: Mock, _ value: Int, expected: Int) {
        let resultA = sut.appending(value)
        let resultB = sut + value

        #expect(resultA == expected)
        #expect(resultB == expected)
    }

    // MARK: Self.Appended == Self
    struct AppendedIsSelf {
        typealias Mock = MockSelfComposable<Int>

        @Test("Appends a value to the type directly", arguments: [
            (Mock(), 5, Mock(5)),
            (Mock(3), 4, Mock(7))
        ])
        func append(_ sut: Mock, _ value: Int, expected: Mock) {
            var sut1 = sut
            var sut2 = sut

            sut1.append(value)
            sut2 += value

            #expect(sut1 == expected)
            #expect(sut2 == expected)
        }

        @Test("Appends multiple values to the type and returns a new version", arguments: [
            (Mock(), 1, 2, 3, Mock(6))
        ])
        func appending(
            _ sut: Mock,
            a: Int,
            b: Int,
            c: Int,
            expected: Mock
        ) {
            var sut = sut
            let result = sut.appending(a, b, c)

            #expect(result == expected)
        }

        @Test("Appends elements from a sequence", arguments: [
            (Mock(15), [1, 2, 3, 4], Mock(25), 4),
            (Mock(6), [1, 2], Mock(9), 2),
            (Mock(14), [1, 2, 3], Mock(20), 3),
            (Mock(25), [4, 9, 7, 2, 0], Mock(47), 4)
        ])
        func appendMany(
            _ sut: Mock,
            _ elements: [Int],
            expected: Mock,
            count: Int
        ) {
            var sut = sut
            let result = sut.appendMany(elements)

            #expect(sut == expected)
            #expect(result == count)
        }
    }

    // MARK: Sequence (EX)
    struct SequenceTests {
        typealias Mock = MockSelfComposable<Int>

        @Test("Appends elements from a sequence to the target", arguments: [
            (Set<Int>([6, 2, 5]), Mock(4), Mock(17))
        ])
        func appending(_ sut: Set<Int>, to target: Mock, expected: Mock) {
            var target = target
            let resultA = sut.appending(to: target)
            sut.appending(into: &target)

            #expect(target == expected)
            #expect(resultA == expected)
        }
    }

    // MARK: Dictionary (EX)
    struct DictionaryTests {
        typealias Mock = [String: Mod]
        typealias Mod = MockSelfComposable<Int>

        @Test("Appends the contents to an Appendable", arguments: [
            (["goal": Mod(4)], 5, "goal", ["goal": Mod(9)]),
            (["block": Mod(9)], 8, "item", ["block": Mod(9), "item": Mod(8)])
        ])
        func appendInside(_ sut: Mock, _ value: Int, for key: String, expected: Mock) {
            var sut = sut
            sut.appendInside(value, for: key)
            #expect(sut == expected)
        }
    }
}
