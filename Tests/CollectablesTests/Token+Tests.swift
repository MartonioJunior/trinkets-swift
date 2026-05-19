//
//  Token+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/09/2025.
//

@testable import Collectables
import Testing

struct TokenTests {
    typealias Mock = Token<String>

    @Test("Creates a new Token that can be used to designate a Trinket", arguments: [
        ("element")
    ])
    func initializer(_ tag: Mock.ID) {
        let sut = Mock(tag)
        #expect(sut.id == tag)
    }

    @Test("Creates a new Amount type")
    func emit() {
        let result = Mock.minting
        #expect(result == TokenMinter.self)
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
        #expect(type(of: Token<String>(stringLiteral: "coin")) == Token<String>.self)
        #expect(type(of: Token<String>.minting.coin) == Token<String>.self)
        #expect(type(of: TokenMinter.coin) == Token<String>.self)
        #expect(type(of: Token<String>("coin")) == Token<String>.self)
    }
}
