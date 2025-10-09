//
//  Token+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

@testable import Collectables
import Testing

struct TokenTests {
    typealias Mock = Token<String, Double>

    @Test("Creates a new Token that can be used to designate a Trinket", arguments: [
        ("element")
    ])
    func initializer(_ tag: Mock.ID) {
        let sut = Mock(tag)
        #expect(sut.id == tag)
    }

    @Test("Creates a new Amount type")
    func emit() {
        let result = Mock.emit(Double.self)
        let expected = Amount<Double>()
        #expect(result == expected)
    }

    // MARK: Self: ExpressibleByIntegerLiteral
    struct ConformsToExpressibleByIntegerLiteral {
        @Test("Creates a new token from String", arguments: [
            ("currency", Mock("currency"))
        ])
        func initializer(stringLiteral value: Mock.ID, expected: Mock) {
            let result = Mock(stringLiteral: value)
            #expect(result == expected)
        }
    }

    @Test("Defines multiple ways to create a quantity")
    func syntax() {
        let quantityA: Token<String, Double> = "coin"
        let quantityB: Token = .emit(Double.self).coin
        let quantityC = Amount<Double>.of("coin")
        let quantityD = Token<String, Double>("coin")

        typealias Material = Token<String, Int>
        let materialA: Material = "arnuCoat"
        let materialB: Material = .emit().arnuCoat
        let materialC = Amount<Int>.of("arnuCoat")
        let materialD = Material("arnuCoat")
    }
}
