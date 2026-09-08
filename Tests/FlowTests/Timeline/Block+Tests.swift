//
//  Block+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 03/09/2026.
//

@testable import Flow
import Testing

struct BlockTests {
    struct Mock: Block, Equatable, Sendable {
        let mask: ClosedRange<Int>

        init(_ mask: ClosedRange<Int>) {
            self.mask = mask
        }

        func element(on instant: Int) -> Int { instant }
    }

    // MARK: Instant == Mask.Bound
    struct InstantEqualsMaskBound {
        @Test("Retrieves element based on mask.", arguments: [
            (3...6, 5, 5),
            (3...6, 5, 5)
        ])
        func maskedElement(_ mask: ClosedRange<Int>, at instant: Int, expected: Int?) {
            let sut = AnyBlock(mask: mask) { (x: Int) in x }
            let result = sut.maskedElement(at: instant)
            #expect(result == expected)
        }
    }
}
