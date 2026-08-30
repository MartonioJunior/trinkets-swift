//
//  RescaledSequence+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

@testable import Flow
import Testing

struct RepeatSequenceTests {
    @Test("Creates a new repeated sequence", arguments: [
        ([3, 2], UInt(4))
    ])
    func initializer(_ sequence: [Int], by amount: UInt) {
        let sut = RepeatSequence(sequence, by: amount)
        #expect(sut.sequence == sequence)
        #expect(sut.amount == amount)
    }

    // MARK: Self: Sequence
    struct ConformsToSequence {
        @Test("Sequence of repeated elements", arguments: [
            ([1, 3], UInt(3), [1, 1, 1, 3, 3, 3]),
            ([1, 3], UInt(1), [1, 3]),
            ([1, 3], UInt(0), [Int]()),
            ([Int](), UInt(4), [Int]())
        ])
        func sequence(_ sut: [Int], _ amount: UInt, expected: [Int]) {
            let result = sut.repeat(amount)
            #expect(result.elementsEqual(expected))
        }
    }
    // MARK: Sequence (EX)
    struct SequenceTests {
        @Test("Sequence of repeated elements", arguments: [
            ([1, 3], UInt(3), RepeatSequence([1, 3], by: 3)),
            ([1, 3], UInt(1), RepeatSequence([1, 3], by: 1)),
            ([1, 3], UInt(0), RepeatSequence([1, 3], by: 0)),
            ([Int](), UInt(4), RepeatSequence<[Int]>([], by: 4))
        ])
        func sequence(_ sut: [Int], _ amount: UInt, expected: RepeatSequence<[Int]>) {
            let result = sut.repeat(amount)
            #expect(result == expected)
        }
    }
}
