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
        (Dimensionality(dictionaryLiteral: (Gil.self, 2)), false),
        (Dimensionality([(RefreshRate.self, -1)]), false),
        (Dimensionality([(Gil.self, 0)]), true),
        (Dimensionality(), true),
        (Dimensionality.dimensionless, true)
    ])
    func isNone(_ sut: Dimensionality, expected: Bool) {
        #expect(sut.isNone == expected)
    }

    @Test("Returns dimensionality for domain type", arguments: [
        (Dimensionality(dictionaryLiteral: (Gil.self, 2)), 2),
        (Dimensionality(dictionaryLiteral: (RefreshRate.self, 1)), 0)
    ])
    func `subscript`(_ sut: Dimensionality, expected: Int) {
        let result = sut[Gil.self]
        #expect(result == expected)
    }

    @Test("Creates a new instance based on a reference domain", arguments: [
        (Gil.self, 1)
    ])
    func initializer(_ type: Gil.Type, expected: Int) {
        let result = Dimensionality(type)
        #expect(result[type] == expected)
    }

    @Test("Creates a new instance based on a Sequence")
    func initializer() {
        let elements: [(any Dimension.Type, Int)] = [(Gil.self, 2), (RefreshRate.self, -1)]
        let result = Dimensionality(elements)

        #expect(result[Gil.self] == 2)
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
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 1)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 3))
        ),
        (
            Dimensionality(dictionaryLiteral: (Gil.self, 2)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 2))
        ),
        (
            Dimensionality(dictionaryLiteral: (Gil.self, -1), (RefreshRate.self, -2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 1))
        ),
        (
            Dimensionality([(Gil.self, 2)]),
            Dimensionality.dimensionless,
            Dimensionality([(Gil.self, 2)])
        )
    ])
    func plus(lhs: Dimensionality, rhs: Dimensionality, expected: Dimensionality) {
        let result = lhs + rhs
        #expect(result == expected)
    }

    @Test("Subtracts out the listed dimensions", arguments: [
        (
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 1)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, -1))
        ),
        (
            Dimensionality(dictionaryLiteral: (Gil.self, 2)),
            Dimensionality(dictionaryLiteral: (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, -2))
        ),
        (
            Dimensionality(dictionaryLiteral: (Gil.self, 1), (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 2)),
            Dimensionality(dictionaryLiteral: (Gil.self, -1))
        ),
        (
            Dimensionality([(Gil.self, 2)]),
            Dimensionality.dimensionless,
            Dimensionality([(Gil.self, 2)])
        )
    ])
    func minus(lhs: Dimensionality, rhs: Dimensionality, expected: Dimensionality) {
        let result = lhs - rhs
        #expect(result == expected)
    }

    @Test("Multiplies dimensions by factor", arguments: [
        (
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, 1)),
            4,
            Dimensionality(dictionaryLiteral: (Gil.self, 8), (RefreshRate.self, 4))
        ),
        (
            Dimensionality(dictionaryLiteral: (Gil.self, -2)),
            3,
            Dimensionality(dictionaryLiteral: (Gil.self, -6))
        ),
        (
            Dimensionality(dictionaryLiteral: (Gil.self, -1), (RefreshRate.self, 2)),
            -2,
            Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, -4))
        ),
        (
            Dimensionality([(Gil.self, 2)]),
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
        let result = Dimensionality(dictionaryLiteral: (Gil.self, 2), (RefreshRate.self, -1))

        #expect(result[Gil.self] == 2)
        #expect(result[RefreshRate.self] == -1)
    }
}
