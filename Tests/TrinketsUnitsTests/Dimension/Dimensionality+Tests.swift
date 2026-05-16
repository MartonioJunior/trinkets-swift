//
//  Dimensionality+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

import Testing
@testable import TrinketsUnits

struct DimensionalityTests {
    @Test("Checks if the system is dimensionless", arguments: [
        (Dimensionality(dictionaryLiteral: (RPGMoney.self, 2)), false),
        (Dimensionality([(RefreshRate.self, -1)]), false),
        (Dimensionality([(RPGMoney.self, 0)]), true),
        (Dimensionality(), true),
        (Dimensionality.dimensionless, true)
    ])
    func isNone(_ sut: Dimensionality, expected: Bool) {
        #expect(sut.isNone == expected)
    }

    @Test("Returns dimensionality for domain type", arguments: [
        (Dimensionality(dictionaryLiteral: (RPGMoney.self, 2)), 2),
        (Dimensionality(dictionaryLiteral: (RefreshRate.self, 1)), 0)
    ])
    func `subscript`(_ sut: Dimensionality, expected: Int) {
        let result = sut[RPGMoney.self]
        #expect(result == expected)
    }

    @Test("Creates a new instance based on a reference domain", arguments: [
        (RPGMoney.self, 1)
    ])
    func initializer(_ type: RPGMoney.Type, expected: Int) {
        let result = Dimensionality(type)
        #expect(result[type] == expected)
    }

    @Test("Creates a new instance based on a Sequence")
    func initializer() {
        let elements: [(any Dimension.Type, Int)] = [(RPGMoney.self, 2), (RefreshRate.self, -1)]
        let result = Dimensionality(elements)

        #expect(result[RPGMoney.self] == 2)
        #expect(result[RefreshRate.self] == -1)
    }

    // MARK: DotSyntax
    @Test("Returns an empty dimension")
    func none() {
        let expected = Dimensionality()
        #expect(Dimensionality.dimensionless == expected)
    }

    // MARK: Operators
    @Test("Adds together the listed dimensions", arguments: [
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 1)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 3))
        ),
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 2))
        ),
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, -1), (RefreshRate.self, -2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 1))
        ),
        (
            Dimensionality([(RPGMoney.self, 2)]),
            Dimensionality.dimensionless,
            Dimensionality([(RPGMoney.self, 2)])
        )
    ])
    func plus(lhs: Dimensionality, rhs: Dimensionality, expected: Dimensionality) {
        let result = lhs + rhs
        #expect(result == expected)
    }

    @Test("Subtracts out the listed dimensions", arguments: [
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 1)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, -1))
        ),
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, -2))
        ),
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 1), (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (RPGMoney.self, -1))
        ),
        (
            Dimensionality([(RPGMoney.self, 2)]),
            Dimensionality.dimensionless,
            Dimensionality([(RPGMoney.self, 2)])
        )
    ])
    func minus(lhs: Dimensionality, rhs: Dimensionality, expected: Dimensionality) {
        let result = lhs - rhs
        #expect(result == expected)
    }

    @Test("Multiplies dimensions by factor", arguments: [
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, 1)),
            4,
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 8), (RefreshRate.self, 4))
        ),
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, -2)),
            3,
            Dimensionality(dictionaryLiteral: (RPGMoney.self, -6))
        ),
        (
            Dimensionality(dictionaryLiteral: (RPGMoney.self, -1), (RefreshRate.self, 2)),
            -2,
            Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, -4))
        ),
        (
            Dimensionality([(RPGMoney.self, 2)]),
            0,
            Dimensionality.dimensionless
        )
    ])
    func multiply(lhs: Dimensionality, rhs: Int, expected: Dimensionality) {
        let result = lhs * rhs
        #expect(result == expected)
    }

    // MARK: Self: ExpressibleByDictionaryLiteral
    @Test("Creates a new instance based on dictionary")
    func initializerDictionaryLiteral() {
        let result = Dimensionality(dictionaryLiteral: (RPGMoney.self, 2), (RefreshRate.self, -1))

        #expect(result[RPGMoney.self] == 2)
        #expect(result[RefreshRate.self] == -1)
    }
}
