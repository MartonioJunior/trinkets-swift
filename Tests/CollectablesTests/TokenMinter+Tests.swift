//
//  TokenMinter+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import Testing

struct TokenMinterTests {
    @Test("Creates a new Amount instance")
    func initializer() {
        let result = TokenMinter()
        let expected = TokenMinter()
        #expect(result == expected)
    }

    @Test("Creates a new Token", arguments: [
        ("element", Token<String>("element"))
    ])
    func `subscript`(dynamicMember member: String, expected: Token<String>) {
        let result = TokenMinter[dynamicMember: member]
        #expect(result == expected)
    }

    @Test("Creates token with tag", arguments: [
        ("apple", Token<String>("apple"))
    ])
    func of(_ tag: String, expected: Token<String>) {
        let result = TokenMinter().mint(tag)
        #expect(result == expected)
    }
}
