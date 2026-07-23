//
//  BoundaryOfOne+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/07/2026.
//

@testable import Flow
import Testing

struct BoundaryOfOneTests {
    @Test("Creates a new BoundaryOfOne", arguments: [
        (12)
    ])
    func initializer(_ instant: Int) {
        let result = BoundaryOfOne(instant)
        #expect(result.instant == instant)
    }

    // MARK: Self: Boundary
    struct ConformsToBoundary {
        @Test("Checks whether the instant is the same", arguments: [
            (BoundaryOfOne<Int>(12), 12, true),
            (BoundaryOfOne<Int>(6), 11, false)
        ])
        func contains(lhs: BoundaryOfOne<Int>, rhs: Int, expected: Bool) {
            let result = lhs ~= rhs
            #expect(result == expected)
        }
    }
}
