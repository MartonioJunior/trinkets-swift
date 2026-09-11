//
//  ToggleMask+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/09/2026.
//

@testable import Flow
import Testing

struct ToggleMaskTests {
    @Test("Creates a new toggle mask", arguments: [
        (true), (false)
    ])
    func initializer(_ isActive: Bool) {
        let sut = ToggleMask(isActive, Int.self)
        #expect(sut.isActive == isActive)
    }
}

extension ToggleMaskTests {
    // MARK: Self: Boundary
    struct ConformsToBoundary {
        @Test("Returns the same output for any bound value.", arguments: [
            (ToggleMask(false, Int.self), 8, false),
            (ToggleMask(true, Int.self), 16, true)
        ])
        func contains(lhs: ToggleMask<Int>, rhs: Int, expected: Bool) {
            let result = lhs ~= rhs
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByBooleanLiteral
    struct ConformsToExpressibleByBooleanLiteral {
        @Test("Creates mask from boolean", arguments: [
            (false, ToggleMask(false, Int.self)),
            (true, ToggleMask(true, Int.self))
        ])
        func initializer(booleanLiteral value: Bool, expected: ToggleMask<Int>) {
            let result: ToggleMask<Int> = .init(booleanLiteral: value)
            #expect(result == expected)
        }
    }
}
