//
//  TrinketKey+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 08/10/2025.
//

@testable import Collectables
import Testing

struct TrinketKeyTests {
    typealias Mock = TrinketKey<TrinketTests.Mock>

    @Test("Creates a new instance for type", arguments: [
        ("Mesa")
    ])
    func initializer(_ id: TrinketTests.Mock.ID) {
        let result = TrinketKey<TrinketTests.Mock>(id)
        #expect(result.referenceID == id)
    }

    @Test("Returns the identifier for a key", arguments: [
        (Mock("isj", TrinketTests.Mock.self), "Mock#isj")
    ])
    func description(_ sut: Mock, expected: String) {
        let result = sut.description
        #expect(result == expected)
    }

    // MARK: Self: ExpressibleByStringLiteral
    struct ConformsToExpressibleByStringLiteral {
        @Test("Creates key from string ID", arguments: [
            ("falcon", Mock("falcon", TrinketTests.Mock.self))
        ])
        func initializer(stringLiteral value: String, expected: Mock) {
            let result = Mock(stringLiteral: value)
            #expect(result == expected)
        }
    }
}

// MARK: Trinket (EX)
extension TrinketTests {
    @Test("Instances key for Trinket", arguments: [
        (Mock("sportila"), TrinketKey("sportila", Mock.self))
    ])
    func key(_ sut: Mock, expected: TrinketKey<Mock>) {
        let result = sut.key
        #expect(result == expected)
    }
}
