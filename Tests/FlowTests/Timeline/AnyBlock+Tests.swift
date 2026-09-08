//
//  AnyBlock+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 03/09/2026.
//

import MatheRange
@testable import Flow
import Testing

struct AnyBlockTests {
    @Test("Creates a new block", arguments: [
        (2...6)
    ])
    func initializer(mask: ClosedRange<Int>) {
        let sut = AnyBlock(mask: mask) { (x: Int) in x }
        #expect(sut.mask == mask)
    }

    @Test("Type-erases another block", arguments: [
        (IndexMap<Int, Int>([1: 2], fallback: 5, map: [IndexMap<Int, Int>.Entry]()))
    ])
    func initializer(_ block: IndexMap<Int, Int>) {
        let sut = AnyBlock(block)
        #expect(sut.mask == block.mask)
    }

    // MARK: DotSyntax
    @Test("Creates new interval with fixed value", arguments: [
        (4...9, 12, AnyBlock<ClosedRange<Int>, Int, Int>(mask: 4...9, f: { _ in 12}))
    ])
    func always(_ mask: ClosedRange<Int>, value: Int, expected: AnyBlock<ClosedRange<Int>, Int, Int>) {
        let result: AnyBlock<ClosedRange<Int>, Int, Int> = .always(mask, value: value)
        #expect(result.mask == expected.mask)
    }
}

extension AnyBlockTests {
    // MARK: Self: Block
    struct ConformsToBlock {
        @Test("Uses function to obtain the element", arguments: [
            (AnyBlock<ClosedRange<Int>, Int, Int>(mask: 4...9, f: { _ in 12}), 6, 12),
            (AnyBlock<ClosedRange<Int>, Int, Int>(mask: 4...9, f: { _ in 12}), 18, 12)
        ])
        func element(_ sut: AnyBlock<ClosedRange<Int>, Int, Int>, on instant: Int, expected: Int) {
            let result = sut.element(on: instant)
            #expect(result == expected)
        }
    }

    struct ConformsToSelectable {
        struct SelectableMask: Boundary, Equatable, Selectable {
            typealias Selection = ClosedRange<Int>
            typealias Bound = Int

            var range: ClosedRange<Int>

            init(_ range: ClosedRange<Int>) {
                self.range = range
            }

            func canBeSelected(by selection: ClosedRange<Int>) -> Bool {
                range.overlaps(selection)
            }

            static func ~= (lhs: Self, rhs: Int) -> Bool {
                lhs.range ~= rhs
            }
        }

        @Test("Validates a selection in relation to the block", arguments: [
            (AnyBlock<SelectableMask, Int, Int>(mask: SelectableMask(4...8), f: { _ in 12 }), 1...2, false),
            (AnyBlock<SelectableMask, Int, Int>(mask: SelectableMask(4...8), f: { _ in 12 }), 6...9, true)
        ])
        func canBeSelected(
            _ sut: AnyBlock<SelectableMask, Int, Int>,
            by selection: ClosedRange<Int>,
            expected: Bool
        ) {
            let result = sut.canBeSelected(by: selection)
            #expect(result == expected)
        }
    }

    // MARK: Self.Mask: BoundaryOfOne
    struct MaskEqualsBoundaryOfOne {
        @Test("Creates instant with function", arguments: [
            (12, AnyBlock<BoundaryOfOne<Int>, Int, Int>(mask: BoundaryOfOne<Int>(12), f: \.self))
        ])
        func instant(_ instant: Int, expected: AnyBlock<BoundaryOfOne<Int>, Int, Int>) {
            let result: AnyBlock<BoundaryOfOne<Int>, Int, Int> = .instant(instant, f: \.self)
            #expect(result.mask == expected.mask)
        }

        @Test("Creates instant with fixed value", arguments: [
            (12, 7, AnyBlock<BoundaryOfOne<Int>, Int, Int>(mask: BoundaryOfOne<Int>(12), f: { _ in 7 }))
        ])
        func point(_ instant: Int, value: Int, expected: AnyBlock<BoundaryOfOne<Int>, Int, Int>) {
            let result: AnyBlock<BoundaryOfOne<Int>, Int, Int> = .point(instant, value: value)
            #expect(result.mask == expected.mask)
        }
    }

    // MARK: Self.Mask: ClosedRange
    struct MaskEqualsClosedRange {
        @Test("Defines block from stamp mask", arguments: [
            (StampOf<Int>(1, elapsed: 2), AnyBlock<ClosedRange<Int>, Int, Int>(mask: 1...3, f: \.self))
        ])
        func stamp(_ stamp: StampOf<Int>, expected: AnyBlock<ClosedRange<Int>, Int, Int>) {
            let result: AnyBlock<ClosedRange<Int>, Int, Int> = .stamp(stamp, f: \.self)
            #expect(result.mask == expected.mask)
        }
    }

    // MARK: Block (EX)
    struct BlockTests {
        @Test("Maps block to a new one")
        func mapElement() {
            let sut = AnyBlock<ClosedRange<Int>, Int, Int>(mask: 1...3) { $0 * 3 }
            let result = sut.mapElement { $0 * 2 }
            let expected = AnyBlock<ClosedRange<Int>, Int, Int>(mask: 1...3) { $0 * 6 }
            #expect(result.mask == expected.mask)
        }
    }
}
