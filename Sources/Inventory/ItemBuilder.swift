//
//  ItemBuilder.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/11/2025.
//

import TrinketsUnits

@resultBuilder
public enum ItemBuilder<Item: Measurable> {
    // MARK: Self.Stock
    public typealias Stock = Item.Measure

    // MARK: Preprocessing
    public static func buildExpression<I: Inventory>(_ expression: I) -> Supply where I.Item == Item {
        .wrap(expression.contents)
    }

    public static func buildExpression(_ expression: Stock) -> Supply {
        .init([expression])
    }

    public static func buildExpression(_ expression: [Stock]) -> Supply {
        .init(expression)
    }

    // MARK: 1-by-1
    public static func buildPartialBlock(first: Supply) -> Supply {
        first
    }

    public static func buildPartialBlock(accumulated: Supply, next: Supply) -> Supply {
        .init(accumulated.items + next.items)
    }

    // MARK: Sequence
    public static func buildBlock(_ components: Supply...) -> Supply {
        .init(components.flatMap(\.items))
    }

    // MARK: if-else-switch
    public static func buildEither(first component: Supply) -> Supply {
        component
    }

    public static func buildEither(second component: Supply) -> Supply {
        component
    }

    public static func buildOptional(_ component: Supply?) -> Supply {
        if let component { component } else { .init([]) }
    }

    // MARK: for-in
    public static func buildArray(_ components: [Supply]) -> Supply {
        .init(components.flatMap(\.items))
    }

    // MARK: Postprocessing
    public static func buildFinalResult(_ component: Supply) -> [Item.Measure] {
        component.items
    }

    @_disfavoredOverload
    public static func buildFinalResult<I: Inventory>(_ component: Supply) -> I where Item == I.Item {
        .init(component.items)
    }

    // MARK: Type Erasure
    public static func buildLimitedAvailability(_ component: Supply) -> Supply {
        component
    }
}

// MARK: Self.Supply
public extension ItemBuilder {
    struct Supply {
        var items: [Stock]

        public init(_ items: [Stock]) { self.items = items }

        static func wrap(_ collection: some Collection<Stock>) -> Self {
            .init(collection.map(\.self))
        }
    }
}

extension ItemBuilder.Supply: Equatable where Item.Measure: Equatable {}
extension ItemBuilder.Supply: Sendable where Item.Measure: Sendable {}

// MARK: Self.Item: Measurable
public extension ItemBuilder where Item: Measurable, Item.Value: ExpressibleByIntegerLiteral {
    static func buildExpression(_ expression: Item) -> Supply {
        .init([expression.x(1)])
    }
}
