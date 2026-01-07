//
//  Chest+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/12/2025.
//

@testable import Inventory
import Testing

struct ChestTests {
    typealias Mock = Chest<MockItem>

    @Test("Creates a new chest with the given contents", arguments: [
        (
            false, [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)],
            [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)]
        ),
        (
            true, [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)],
            [MockItem.number(4).x(3), MockItem.number(2).x(8)]
        ),
        (
            false, [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)],
            [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)]
        ),
        (
            true, [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)],
            [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)]
        )
    ])
    func initializer(
        _ stack: Bool,
        _ contents: [MockItem.Measure],
        expectedItems: [MockItem.Measure]
    ) {
        let result = Mock(stack: stack) { contents }
        #expect(result.contents == expectedItems)
        #expect(result.stack == stack)
    }

    // MARK: Self: Catalogue
    @Test("Obtains contents of chest via mapper", arguments: [
        (
            Mock([MockItem.number(3).x(7), MockItem.number(8).x(2)]),
            true, [MockItem.number(3), MockItem.number(8)]
        ),
        (Mock(), true, [MockItem]()),
        (
            Mock([MockItem.number(3).x(7), MockItem.number(8).x(2)]),
            false, [MockItem]()
        ),
        (Mock(), true, [MockItem]())
    ])
    func fetch(
        _ sut: Mock,
        compose: Bool,
        expected: [MockItem]
    ) {
        let result = sut.fetch { compose ? $0.unit : nil }
        #expect(result == expected)
    }

    // MARK: Self: Depot
    @Test("Stores measure into the chest", arguments: [
        (
            Mock(stack: true, { [MockItem.number(3).x(7)] }),
            MockItem.number(8).x(2),
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(3),
            Mock(stack: true, { [MockItem.number(3).x(10), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [] }),
            MockItem.number(8).x(2),
            Mock(stack: true, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7)] }),
            MockItem.number(8).x(2),
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(3),
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2), MockItem.number(3).x(3)] })
        ),
        (
            Mock(stack: false, { [] }),
            MockItem.number(8).x(2),
            Mock(stack: false, { [MockItem.number(8).x(2)] })
        )
    ])
    func store(
        _ sut: Mock,
        _ content: MockItem.Measure,
        expectedSut: Mock
    ) {
        var sut = sut
        let result = sut.store(content)
        #expect(result == nil)
        #expect(sut == expectedSut)
    }

    // MARK: Self: Dispenser
    @Test("Releases contents from the chest", arguments: [
        (
            Mock(stack: true, { [MockItem.number(3).x(7)] }),
            MockItem.number(8).x(2),
            MockItem.number(8).x(2),
            Mock(stack: true, { [MockItem.number(3).x(7)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(3),
            MockItem.Measure?.none,
            Mock(stack: true, { [MockItem.number(3).x(4), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(11),
            MockItem.number(3).x(4),
            Mock(stack: true, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(.infinite), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(3),
            MockItem.Measure?.none,
            Mock(stack: true, { [MockItem.number(3).x(.infinite), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(.nullify),
            MockItem.Measure?.none,
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(.infinite),
            MockItem.Measure?.none,
            Mock(stack: true, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [MockItem.number(3).x(.infinite), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(.infinite),
            MockItem.Measure?.none,
            Mock(stack: true, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: true, { [] }),
            MockItem.number(8).x(2),
            MockItem.number(8).x(2),
            Mock(stack: true, { [] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7)] }),
            MockItem.number(8).x(2),
            MockItem.number(8).x(2),
            Mock(stack: false, { [MockItem.number(3).x(7)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(3),
            MockItem.Measure?.none,
            Mock(stack: false, { [MockItem.number(3).x(4), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(11),
            MockItem.number(3).x(4),
            Mock(stack: false, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(.infinite), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(3),
            MockItem.Measure?.none,
            Mock(stack: false, { [MockItem.number(3).x(.infinite), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(.nullify),
            MockItem.Measure?.none,
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(7), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(.infinite),
            MockItem.Measure?.none,
            Mock(stack: false, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [MockItem.number(3).x(.infinite), MockItem.number(8).x(2)] }),
            MockItem.number(3).x(.infinite),
            MockItem.Measure?.none,
            Mock(stack: false, { [MockItem.number(8).x(2)] })
        ),
        (
            Mock(stack: false, { [] }),
            MockItem.number(8).x(2),
            MockItem.number(8).x(2),
            Mock(stack: false, { [] })
        )
    ])
    func release(
        _ sut: Mock,
        _ content: MockItem.Measure,
        expected: MockItem.Measure?,
        expectedSut: Mock
    ) {
        var sut = sut
        let result = sut.release(content)
        #expect(result == expected)
        #expect(sut == expectedSut)
    }

    // MARK: Self: ItemCollection
    @Test("Creates a non-stack chest from a list of contents", arguments: [
        (
            [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)],
            Mock(stack: false, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)] })
        ),
        (
            [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)],
            Mock(stack: false, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)] })
        )
    ])
    func initializer(
        _ contents: [MockItem.Measure],
        expected: Mock
    ) {
        let result = Mock(contents)
        #expect(result == expected)
    }

    // MARK: Self: Inventory
    @Test("Lists all the contents in the chest", arguments: [
        (
            Mock(stack: false, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)] }),
            [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)]
        ),
        (
            Mock(stack: false, { [] }),
            [MockItem.Measure]()
        ),
        (
            Mock(stack: true, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)] }),
            [MockItem.number(4).x(3), MockItem.number(2).x(8)]
        ),
        (
            Mock(stack: true, { [] }),
            [MockItem.Measure]()
        )
    ])
    func contents(
        _ sut: Mock,
        expected: [MockItem.Measure]
    ) {
        #expect(sut.contents == expected)
    }

    // MARK: Self.Item.Value: AdditiveArithmetic
    @Test("Optimizes chest by combining similar elements", arguments: [
        (
            Mock(stack: false, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(2).x(3)] }),
            Mock(stack: false, { [MockItem.number(4).x(3), MockItem.number(2).x(8)] })
        ),
        (
            Mock(stack: false, { [] }),
            Mock(stack: false, { [] })
        ),
        (
            Mock(stack: true, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)] }),
            Mock(stack: true, { [MockItem.number(4).x(3), MockItem.number(2).x(5), MockItem.number(6).x(3)] })
        ),
        (
            Mock(stack: true, { [] }),
            Mock(stack: true, { [] })
        )
    ])
    func optimize(
        _ sut: Mock,
        expected: Mock
    ) {
        var sut = sut
        sut.optimize()
        #expect(sut == expected)
    }
}
