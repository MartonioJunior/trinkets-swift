//
//  Removable+Tests.swift
//  Core
//
//  Created by Martônio Júnior on 30/05/2025.
//

@testable import Custom
import Testing

internal struct RemovableTests {
    typealias Mock = MockComposable<Int, Int>

    @Test("Removes a value from the type", arguments: [
        (Mock.additive(8), 5, 3),
        (Mock.additive(), 4, -4)
    ])
    func removing(_ sut: Mock, _ value: Int, expected: Int) {
        let resultA = sut.removing(value)
        let resultB = sut - value

        #expect(resultA == expected)
        #expect(resultB == expected)
    }

    // MARK: Self.Removed == Self
    struct RemovedIsSelf {
        typealias Mock = MockSelfComposable<Int>

        @Test("Removes a value from the type directly", arguments: [
            (Mock(), 5, Mock(-5)),
            (Mock(3), 4, Mock(-1))
        ])
        func remove(_ sut: Mock, _ value: Int, expected: Mock) {
            var sut1 = sut
            var sut2 = sut

            sut1.remove(value)
            sut2 -= value

            #expect(sut1 == expected)
            #expect(sut2 == expected)
        }

        @Test("Removes multiple values to the type and returns a new version", arguments: [
            (Mock(9), 1, 2, 3, Mock(3))
        ])
        func removing(
            _ sut: Mock,
            a: Int,
            b: Int,
            c: Int,
            expected: Mock
        ) {
            var sut = sut
            let result = sut.removing(a, b, c)

            #expect(result == expected)
        }

        @Test("Removes using a sequence of elements", arguments: [
            (Mock(15), [1, 2, 3, 4], Mock(5), 4),
            (Mock(6), [1, 2], Mock(3), 2),
            (Mock(14), [1, 2, 3], Mock(8), 3),
            (Mock(25), [4, 9, 7, 2, 0], Mock(3), 4)
        ])
        func removeMany(
            _ sut: Mock,
            _ elements: [Int],
            expected: Mock,
            count: Int
        ) {
            var sut = sut
            let result = sut.removeMany(elements)

            #expect(sut == expected)
            #expect(result == count)
        }
    }

    // MARK: Self: Sequence
    struct SequenceTests {
        typealias Mock = MockSelfComposable<Int>

        @Test("Appends elements from a sequence to the target", arguments: [
            (Set<Int>([6, 2, 5]), Mock(4), Mock(-9))
        ])
        func removing(_ sut: Set<Int>, to target: Mock, expected: Mock) {
            var target = target
            let resultA = sut.removing(from: target)
            sut.removing(from: &target)

            #expect(target == expected)
            #expect(resultA == expected)
        }
    }

    // MARK: Dictionary (EX)
    struct DictionaryTests {
        typealias Mock = [String: Mod]
        typealias Mod = MockSelfComposable<Int>

        @Test("Removes the contents from a Removable", arguments: [
            (["goal": Mod(4)], 5, "goal", ["goal": Mod(-1)]),
            (["block": Mod(2)], 3, "item", ["block": Mod(2)])
        ])
        func removeInside(_ sut: Mock, _ value: Int, for key: String, expected: Mock) {
            var sut = sut
            sut.removeInside(value, for: key)
            #expect(sut == expected)
        }

        @Test("Removes contents from all elements", arguments: [
            (["goal": Mod(4)], 5, ["goal": Mod(-1)]),
            (["block": Mod(2), "goal": Mod(12)], 3, ["block": Mod(-1), "goal": Mod(9)])
        ])
        func removeInsideAll(_ sut: Mock, _ value: Int, expected: Mock) {
            var sut = sut
            sut.removeInsideAll(value)
            #expect(sut == expected)
        }
    }
}
