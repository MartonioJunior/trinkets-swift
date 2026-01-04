//
//  ItemBuilder+Tests.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/12/2025.
//

@testable import Inventory
import Testing
import TrinketsUnits

struct ItemBuilderTests {
    typealias Item = MockItem
    typealias Mock = ItemBuilder<Item>

    // MARK: Preprocessing
    @Test("Wraps inventory as a Supply", arguments: [
        (
            Chest([Item.number(4).x(5), Item.number(3).x(2)]),
            Mock.Supply([Item.number(4).x(5), Item.number(3).x(2)])
        )
    ])
    func buildExpressionInventory(_ expression: Chest<Item>, expected: Mock.Supply) {
        let result = ItemBuilder.buildExpression(expression)
        #expect(result == expected)
    }

    @Test("Wraps stock as a Supply", arguments: [
        (
            Item.text("energy").x(3),
            Mock.Supply([Item.text("energy").x(3)])
        )
    ])
    func buildExpressionStock(_ expression: Item.Measure, expected: Mock.Supply) {
        let result = ItemBuilder.buildExpression(expression)
        #expect(result == expected)
    }

    @Test("Wraps array of stock as a Supply", arguments: [
        (
            [Item.number(4).x(5), Item.text("gol").x(2)],
            Mock.Supply([Item.number(4).x(5), Item.text("gol").x(2)])
        )
    ])
    func buildExpressionStock(_ expression: [Item.Measure], expected: Mock.Supply) {
        let result = ItemBuilder.buildExpression(expression)
        #expect(result == expected)
    }

    // MARK: 1-by-1
    @Test("Returns the supply instance", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.text("energy").x(3)])
        )
    ])
    func buildPartialBlock(first: Mock.Supply, expected: Mock.Supply) {
        let result = ItemBuilder.buildPartialBlock(first: first)
        #expect(result == expected)
    }

    @Test("Accumulates the supply instance with another", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.number(4).x(9)]),
            Mock.Supply([Item.text("energy").x(3), Item.number(4).x(9)])
        )
    ])
    func buildPartialBlock(accumulated: Mock.Supply, next: Mock.Supply, expected: Mock.Supply) {
        let result = ItemBuilder.buildPartialBlock(accumulated: accumulated, next: next)
        #expect(result == expected)
    }

    // MARK: Sequence
    @Test("Flattens a collection of supply instances", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.number(4).x(9)]),
            Mock.Supply([Item.number(6).x(27), Item.number(9).x(1)]),
            Mock.Supply([Item.text("energy").x(3), Item.number(4).x(9), Item.number(6).x(27), Item.number(9).x(1)])
        )
    ])
    func buildBlock(a: Mock.Supply, b: Mock.Supply, c: Mock.Supply, expected: Mock.Supply) {
        let result = ItemBuilder.buildBlock(a, b, c)
        #expect(result == expected)
    }

    // MARK: if-else-switch
    @Test("Returns the first component of a conditional clause", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.text("energy").x(3)])
        )
    ])
    func buildEither(first component: Mock.Supply, expected: Mock.Supply) {
        let result = ItemBuilder.buildEither(first: component)
        #expect(result == expected)
    }

    @Test("Returns the second component of a conditional clause", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.text("energy").x(3)])
        )
    ])
    func buildEither(second component: Mock.Supply, expected: Mock.Supply) {
        let result = ItemBuilder.buildEither(second: component)
        #expect(result == expected)
    }

    @Test("Handles the conditional possibility of an element", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.text("energy").x(3)])
        ),
        (
            Mock.Supply?.none,
            Mock.Supply([])
        )
    ])
    func buildOptional(_ component: Mock.Supply?, expected: Mock.Supply) {
        let result = ItemBuilder.buildOptional(component)
        #expect(result == expected)
    }

    // MARK: for-in
    @Test("Returns the array created by a loop", arguments: [
        (
            [
                Mock.Supply([Item.text("energy").x(3)]),
                Mock.Supply([Item.number(4).x(9)]),
                Mock.Supply([Item.number(6).x(27), Item.number(9).x(1)])
            ],
            Mock.Supply([Item.text("energy").x(3), Item.number(4).x(9), Item.number(6).x(27), Item.number(9).x(1)])
        )
    ])
    func buildArray(_ components: [Mock.Supply], expected: Mock.Supply) {
        let result = ItemBuilder.buildArray(components)
        #expect(result == expected)
    }

    // MARK: Postprocessing
    @Test("Outputs an array of measurements", arguments: [
        (
            Mock.Supply([Item.number(4).x(5), Item.text("gol").x(2)]),
            [Item.number(4).x(5), Item.text("gol").x(2)]
        )
    ])
    func buildFinalResultMeasurements(_ component: Mock.Supply, expected: [Item.Measure]) {
        let result: [Item.Measure] = ItemBuilder.buildFinalResult(component)
        #expect(result == expected)
    }

    @Test("Outputs an inventory with the given contents", arguments: [
        (
            Mock.Supply([Item.number(4).x(5), Item.text("gol").x(2)]),
            Chest([Item.number(4).x(5), Item.text("gol").x(2)])
        )
    ])
    func buildFinalResultInventory(_ component: Mock.Supply, expected: Chest<Item>) {
        let result: Chest<Item> = ItemBuilder.buildFinalResult(component)
        #expect(result == expected)
    }

    // MARK: Type Erasure
    @Test("Defines limited availability for the supply", arguments: [
        (
            Mock.Supply([Item.text("energy").x(3)]),
            Mock.Supply([Item.text("energy").x(3)])
        )
    ])
    func buildLimitedAvailability(_ component: Mock.Supply, expected: Mock.Supply) {
        let result = ItemBuilder.buildLimitedAvailability(component)
        #expect(result == expected)
    }
}

// MARK: Self.Item: Measurable
extension ItemBuilderTests {
    @Test("Wraps item as a supply", arguments: [
        (
            Item.text("energy"),
            Mock.Supply([Item.text("energy").x(1)])
        )
    ])
    func buildExpressionItem(_ expression: Item, expected: Mock.Supply) {
        let result = ItemBuilder.buildExpression(expression)
        #expect(result == expected)
    }
}

// MARK: Syntax Validation
extension ItemBuilderTests {
    @Mock func syntaxArray() -> [Item.Measure] {
        Item.number(2) * 49
        Item.text("yes")
        Item.number(84)

        var x = 6
        var goal = "mask"

        if x < 10 {
            Item.text("Energy Cell")
        }

        switch goal {
            case "mask":
                Item.number(22)
            default:
                []
        }

        for n in [25, 34, 99] {
            Item.number(n)
        }

        if #available(iOS 26, *) {
            Chest {
                Item.number(88)
                Item.text("medal")
            }
        } else {
            Item.text("lollipop")
        }
    }

    @Mock func syntaxInventory() -> Chest<Item> {
        .number(2) * 49;
        .text("yes");
        .number(84);

        var x = 4
        var goal = "mask"

        if x > 10 {
        } else {
            Item.text("Energy Cell")
        }

        switch goal {
            case "legs":
                Item.number(22)
            default:
                []
        }

        for n in 3...5 {
            Item.text("Item \(n)")
        }

        if #unavailable(iOS 26) {
            Chest {
                Item.number(31)
                Item.text("ribbon")
            }
        } else {
            Item.text("orange")
        }
    }

    @Mock func singleItem(_ item: Item.Measure) -> [Item.Measure] {
        item
    }
}
