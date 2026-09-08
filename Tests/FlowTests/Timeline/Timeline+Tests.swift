//
//  Timeline+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/09/2026.
//

import CustomDump
@testable import Flow
import Minimal
import Testing

struct TimelineTests {
    typealias Mock = Timeline<BlockTests.Mock, IndexMap<String, Int>>

    @Test("Creates a new timeline", arguments: [
        (BlockTests.Mock(2...5), IndexMap<String, Int>(fallback: "yes"))
    ])
    func initializer(_ a: BlockTests.Mock, _ b: IndexMap<String, Int>) {
        let sut = Timeline(Tuple(a, b))
        let expectedTracks = Tuple(a, b)
        #expect(sut.blocks == expectedTracks)
    }

    // MARK: Methods
    @Test("Performs an operation to a given block")
    func mutateBlock() {
        var sut = Timeline(Tuple(BlockTests.Mock(2...5), IndexMap<String, Int>(fallback: "yes")))
        expectDifference(sut) {
            sut.mutateBlock(\.0) { $0 = BlockTests.Mock(3...8) }
        } changes: {
            $0.blocks = Tuple(
                BlockTests.Mock(3...8), IndexMap<String, Int>(fallback: "yes")
            )
        }
    }

    @Test("Maps a block in the timeline into a value", arguments: [
        (
            Mock(
                Tuple<BlockTests.Mock, IndexMap<String, Int>>(
                    BlockTests.Mock(2...5),
                    IndexMap<String, Int>(fallback: "yes")
                )
            ), "yes"
        )
    ])
    func withBlock(_ sut: Mock, expected: String) {
        let result = sut.withBlock(\.1, transform: \.fallback)
        #expect(result == expected)
    }
}

extension TimelineTests {
    // MARK: Self: Block
    struct ConformsToBlock {
        @Test("Mask is a tuple of masks", arguments: [
            (
                Mock(Tuple(BlockTests.Mock(2...5), IndexMap<String, Int>(fallback: "yes"))),
                Tuple<ClosedRange<Int>, IndexMap<String, Int>>(2...5, IndexMap<String, Int>(fallback: "yes"))
            )
        ])
        func mask(_ sut: Mock, expected: Tuple<ClosedRange<Int>, IndexMap<String, Int>>) {
            #expect(sut.mask == expected)
        }

        @Test("Returns a sampled tuple of elements", arguments: [
            (
                Mock(Tuple(BlockTests.Mock(2...5), IndexMap<String, Int>(fallback: "yes"))),
                Tuple<Int, Int>(3, 8),
                Tuple<Int, String>(3, "yes")
            )
        ])
        func element(_ sut: Mock, on instant: Tuple<Int, Int>, expected: Tuple<Int, String>) {
            let result = sut.element(on: instant)
            #expect(result == expected)
        }
    }

    // MARK: Tuple (EX)
    struct TupleTests {
        typealias Mock = Tuple<ClosedRange<Int>, IndexMap<String, Int>>

        @Test("Overlap applies to any lane", arguments: [
            (
                Mock(
                    2...5,
                    IndexMap<String, Int>(
                        [2: "goal"],
                        fallback: "yes",
                        map: [IndexMap<String, Int>.Entry(9, to: 2)]
                    )
                ),
                Tuple<Int, Int>(3, 10),
                true
            ),
            (
                Mock(
                    2...5,
                    IndexMap<String, Int>(
                        [2: "goal"],
                        fallback: "yes",
                        map: [IndexMap<String, Int>.Entry(9, to: 2)]
                    )
                ),
                Tuple<Int, Int>(8, 10),
                true
            ),
            (
                Mock(2...5, IndexMap<String, Int>(fallback: "yes")),
                Tuple<Int, Int>(3, 8),
                true
            ),
            (
                Mock(2...5, IndexMap<String, Int>(fallback: "yes")),
                Tuple<Int, Int>(8, 8),
                false
            )
        ])
        func contains(lhs: Mock, rhs: Tuple<Int, Int>, expected: Bool) {
            let result = lhs ~= rhs
            #expect(result == expected)
        }
    }
}
