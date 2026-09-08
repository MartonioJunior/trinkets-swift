//
//  MaskedBlock+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 07/09/2026.
//

import CustomDump
@testable import Flow
import Testing

struct MaskedBlockTests {
    typealias Chunk = BlockTests.Mock
    @Test("Creates a new masked block", arguments: [
        (Chunk(3...5), ["base": 3...9])
    ])
    func initializer(_ block: Chunk, masks: [String: ClosedRange<Int>]) {
        let sut = MaskedBlock<String, Chunk>(block, masks: masks)
        #expect(sut.block == block)
        #expect(sut.masks == masks)
    }

    // MARK: Methods
    @Test("Creates chunk from a slice", arguments: [
        (
            MaskedBlock<String, Chunk>(.init(3...6), masks: ["light": 3...9]),
            "light",
            AnyBlockOf<Chunk>(Chunk(3...9))
        ),
        (
            MaskedBlock<String, Chunk>(.init(3...6), masks: ["light": 3...9]),
            "ball",
            Optional<AnyBlockOf<Chunk>>.none
        )
    ])
    func chunk(_ sut: MaskedBlock<String, Chunk>, forKey key: String, expected: AnyBlockOf<Chunk>?) {
        let result = sut.chunk(forKey: key)
        #expect(result?.mask == expected?.mask)
    }

    @Test("Obtains registered masks using key", arguments: [
        (
            MaskedBlock<String, Chunk>(.init(3...6), masks: ["light": 3...9]),
            "light",
            3...9
        ),
        (
            MaskedBlock<String, Chunk>(.init(3...6), masks: ["light": 3...9]),
            "goal",
            Optional<ClosedRange<Int>>.none
        )
    ])
    func mask(_ sut: MaskedBlock<String, Chunk>, forKey key: String, expected: ClosedRange<Int>?) {
        let result = sut.mask(forKey: key)
        #expect(result == expected)
    }

    @Test("Creates a mask for the block")
    func register() {
        var newMask = MaskedBlock<String, Chunk>(.init(3...6), masks: [:])
        expectDifference(newMask) {
            newMask.register(3...9, forKey: "lollipop")
        } changes: {
            $0.masks = ["lollipop": 3...9]
        }

        var updateMask = MaskedBlock<String, Chunk>(.init(3...6), masks: ["lollipop": 1...9])
        expectDifference(updateMask) {
            updateMask.register(5...6, forKey: "lollipop")
        } changes: {
            $0.masks = ["lollipop": 5...6]
        }
    }

    @Test("Removes mask using it's key")
    func removeKey() {
        var maskExists = MaskedBlock<String, Chunk>(.init(3...6), masks: ["lollipop": 1...9])
        expectDifference(maskExists) {
            maskExists.removeKey("lollipop")
        } changes: {
            $0.masks = [:]
        }

        let keyNotFound = MaskedBlock<String, Chunk>(.init(3...9), masks: ["lollipop": 1...9])
        expectNoChanges(keyNotFound) {
            $0.removeKey("apple")
        }
    }
}

extension MaskedBlockTests {
    // MARK: Self: Block
    struct ConformsToBlock {
        @Test("Returns the mask for the block", arguments: [
            (MaskedBlock<String, Chunk>(.init(3...6), masks: ["light": 3...9]), 3...6)
        ])
        func mask(_ sut: MaskedBlock<String, Chunk>, expected: ClosedRange<Int>) {
            #expect(sut.mask == expected)
        }

        @Test("Returns an element for the underlying block", arguments: [
            (
                MaskedBlock<String, Chunk>(.init(3...6), masks: ["light": 3...9]),
                12,
                12
            )
        ])
        func element(_ sut: MaskedBlock<String, Chunk>, on instant: Int, expected: Int) {
            let result = sut.element(on: instant)
            #expect(result == expected)
        }
    }
}
