//
//  Amount+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import Testing

struct AmountTests {
    typealias Mock = Amount<Double>

    @Test("Creates a new Amount instance")
    func initializer() {
        let result = Mock()
    }

    @Test("Creates a new Token", arguments: [
        (Mock(), "element", Token<String, Double>("element"))
    ])
    func `subscript`(_ sut: Mock, dynamicMember member: String, expected: Token<String, Double>) {
        let result = sut[dynamicMember: member]
        #expect(result == expected)
    }

    @Test("Creates token with tag", arguments: [
        ("apple", Token<String, Double>("apple"))
    ])
    func of(_ tag: String, expected: Token<String, Double>) {
        let result = Mock.of(tag)
        #expect(result == expected)
    }
}
