//
//  PolynomialConverter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/09/2025.
//

import Testing
@testable import TrinketsUnits

struct PolynomialConverterTests {
    @available(macOS 26.0, *)
    typealias Mock = PolynomialConverter<3, Double>

    @available(macOS 26.0, *)
    @Test("Creates a new array based on a set of coefficients", arguments: [
        ([1, 2, 3])
    ])
    func initializer(_ coefficients: InlineArray<3, Double>) {
        let result = PolynomialConverter(coefficients)
        #expect(result.coefficients == coefficients)
    }

    @available(macOS 26.0, *)
    @Test("Returns the element not affected by the input", arguments: [
        (PolynomialConverter([1, 2, 3]), 3)
    ])
    func constant(_ sut: Mock, expected: Mock.Value) {
        #expect(sut.constant == expected)
    }

    @available(macOS 26.0, *)
    @Test("Returns the coefficient for the desired exponent", arguments: [
        (PolynomialConverter([1, 2, 3]), 0, 3),
        (PolynomialConverter([4, 5, 6]), 1, 5),
        (PolynomialConverter([7, 8, 9]), 2, 7),
        (PolynomialConverter([3, 5, 4]), -1, 0),
        (PolynomialConverter([1, 5, 8]), 3, 0)
    ])
    func `subscript`(_ sut: Mock, e power: Int, expected: Mock.Value) {
        #expect(sut[e: power] == expected)
    }

    // MARK: Self: Converter
    struct ConformsToConverter {
        @available(macOS 26.0, *)
        @Test("Returns result of function", arguments: [
            (Mock([5, 3, 4]), 6, 202),
            (Mock([0, 3, 4]), 6, 22),
            (Mock([5, 0, -4]), 6, 176),
            (Mock([-5, 3, 0]), 6, -162),
            (Mock([0, 0, 4]), 6, 4),
            (Mock([0, -3, 0]), 6, -18),
            (Mock([0, 0, 0]), 6, 0)
        ])
        func baseValue(_ sut: Mock, of value: Mock.Value, expected: Mock.Value) {
            let result = sut.baseValue(of: value)
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Returns value when function returns specified result", arguments: [
            (Mock([5, 3, 4]), 6, Mock.Value?.none),
            (Mock([0, 3, 4]), 6, Mock.Value?.none),
            (Mock([5, 0, -4]), 6, Mock.Value?.none),
            (Mock([-5, 3, 0]), 6, Mock.Value?.none),
            (Mock([0, 0, 4]), 6, Mock.Value?.none),
            (Mock([0, -3, 0]), 6, Mock.Value?.none),
            (Mock([0, 0, 0]), 6, Mock.Value?.none)
        ])
        func convert(_ sut: Mock, _ value: Mock.Value, expected: Mock.Value?) {
            let result = sut.convert(value)
            #expect(result == expected)
        }
    }

    // MARK: Self: ExpressibleByArrayLiteral
    struct ConformsToExpressibleByArrayLiteral {
        @available(macOS 26.0, *)
        @Test("Creates function based on array of coefficients")
        func initializerArrayLiteral() {
            // More than the amount required
            let methodA = PolynomialFunction<2, Double>(arrayLiteral: 2, 4, 6, 7)
            #expect(methodA == PolynomialFunction([2, 4]))

            // Less than the amount required
            let methodB = PolynomialFunction<3, Double>(arrayLiteral: 3, 1)
            #expect(methodB == PolynomialFunction([3, 1, 0]))

            // Exactly the amount required
            let methodC = PolynomialFunction<3, Double>(arrayLiteral: 4, 5, 6)
            #expect(methodC == PolynomialFunction([4, 5, 6]))

            // Empty Array
            let methodD = PolynomialFunction<3, Double>()
            #expect(methodD == PolynomialFunction([0, 0, 0]))
        }
    }

    // MARK: N == 1
    struct Nis1 {
        @available(macOS 26.0, *)
        typealias Mock = PolynomialConverter<1, Double>

        @available(macOS 26.0, *)
        @Test("Returns function constant to one")
        func one() {
            let result = Mock.one
            let expected = Mock([1])
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Returns function constant to a value", arguments: [
            (7)
        ])
        func constant(_ k: Double) {
            let result = Mock.constant(k)
            let expected = Mock([k])
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Always returns constant", arguments: [
            (Mock([5]), 6, 5),
            (Mock([2]), 0, 2),
            (Mock([3]), -4, 3)
        ])
        func convert(_ sut: Mock, _ value: Mock.Value, expected: Mock.Value) {
            let result = sut.convert(value)
            #expect(result == expected)
        }
    }

    // MARK: N == 2
    struct Nis2 {
        @available(macOS 26.0, *)
        typealias Mock = PolynomialConverter<2, Double>

        @available(macOS 26.0, *)
        @Test("Returns function with coefficient 1, constant 0")
        func unit() {
            let result = Mock.unit
            let expected = Mock([1, 0])
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Returns a quadratic polynomial", arguments: [
            (Mock([2, 4]), Mock([1, 9]), QuadraticFunction<Double>([2, 22, 36]))
        ])
        func multiply(lhs: Mock, rhs: Mock, expected: QuadraticFunction<Double>) {
            let result = lhs * rhs
            #expect(result == expected)
        }

        struct TisFloatingPoint {
            @available(macOS 26.0, *)
            @Test("Returns value of linear function with specified result", arguments: [
                (Mock([2, 3]), 5, 1),
                (Mock([2, 0]), 5, 2.5),
                (Mock([0, 3]), 5, nil),
                (Mock([2, -3]), 5, 4),
                (Mock([-3, 3]), 15, -4),
                (Mock([0, 0]), 99, nil)
            ])
            func convert(_ sut: Mock, _ value: Mock.Value, expected: Mock.Value?) {
                let result = sut.convert(value)
                #expect(result == expected)
            }
        }
    }

    // MARK: N == 3
    struct Nis3 {
        @available(macOS 26.0, *)
        typealias Mock = PolynomialConverter<3, Double>

        @available(macOS 26.0, *)
        @Test("Downgrades to a linear polynomial", arguments: [
            (Mock([2, 3, 4]), LinearFunction<Double>([4, 3]))
        ])
        func formalDerivative(_ sut: Mock, expected: LinearFunction<Double>) {
            let result = sut.formalDerivative
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Defines a quadratic polynomial", arguments: [
            (1, 2, 4, Mock([1, 2, 4]))
        ])
        func quadratic(_ a: Double, b: Double = 0, c: Double = 0, expected: Mock) {
            let result = Mock.quadratic(a, b: b, c: c)
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Returns a cubic polynomial", arguments: [
            (Mock([3, 8, 4]), LinearFunction<Double>([2, 9]), CubicFunction<Double>([6, 43, 80, 36]))
        ])
        func multiply(lhs: Mock, rhs: LinearFunction<Double>, expected: CubicFunction<Double>) {
            let result = lhs * rhs
            #expect(result == expected)
        }
    }

    // MARK: N == 4
    struct Nis4 {
        @available(macOS 26.0, *)
        typealias Mock = PolynomialConverter<4, Double>

        @available(macOS 26.0, *)
        @Test("Downgrades to a quadratic polynomial", arguments: [
            (Mock([2, 3, 4, 5]), QuadraticFunction<Double>([6, 6, 4]))
        ])
        func formalDerivative(_ sut: Mock, expected: QuadraticFunction<Double>) {
            let result = sut.formalDerivative
            #expect(result == expected)
        }

        @available(macOS 26.0, *)
        @Test("Defines a cubic polynomial", arguments: [
            (1, 2, 4, 8, Mock([1, 2, 4, 8]))
        ])
        func cubic(_ a: Double, b: Double, c: Double, d: Double, expected: Mock) {
            let result = Mock.cubic(a, b: b, c: c, d: d)
            #expect(result == expected)
        }
    }

    // MARK: T: Numeric
    struct TConformsToNumeric {
        @available(macOS 26.0, *)
        @Test("Multiplies the coefficients by a value", arguments: [
            (Mock([3, 8, 4]), 3, Mock([9, 24, 12]))
        ])
        func multiply(lhs: Mock, rhs: Double, expected: Mock) {
            let result = lhs * rhs
            #expect(result == expected)
        }
    }

    // MARK: T: FloatingPoint
    struct TConformsToFloatingPoint {
        @available(macOS 26.0, *)
        @Test("Divides the coefficients by a value", arguments: [
            (Mock([9, 24, 12]), 3, Mock([3, 8, 4]))
        ])
        func divide(lhs: Mock, rhs: Double, expected: Mock) {
            let result = lhs / rhs
            #expect(result == expected)
        }
    }
}

// MARK: InlineArray (EX)
struct InlineArrayTests {
    @available(macOS 26.0, *)
    @Test("Compares coefficient by coefficient", arguments: [
        ([2 of Int] { $0 + 2 }, [2 of Int] { $0 + 4 }, false),
        ([2 of Int] { $0 + 2 }, [2 of Int] { 3 * $0 + 2 }, false),
        ([2 of Int] { $0 + 1 }, [2 of Int] { $0 + 1 }, true)
    ])
    func equals(lhs: InlineArray<2, Int>, rhs: InlineArray<2, Int>, expected: Bool) {
        let result = lhs == rhs
        #expect(result == expected)
    }
}
