//
//  ItemBuilder.swift
//  Trinkets
//
//  Created by Martônio Júnior on 11/11/2025.
//

import TrinketsUnits

/// Builder for composing items into stock.
/// - Item: Type of item used in this builder.
/// 
/// This can be used to compose a list of contents for an inventory or for checking contents.
/// 
/// Allows using an item, a measurement or even an entire inventory's contents:
/// ```swift
/// @ItemBuilder var items: [Measurement<Material, Tally>] {
///   wood
///   iron.x(15)
///   tableChest
///   // ...
/// }
/// ```
/// 
/// It's results can build either:
/// - A `Supply`
/// - An `Inventory`
/// - A list of measurements.
@resultBuilder
public enum ItemBuilder<Item: Quantifiable> {
    // MARK: Preprocessing
    /// Extracts contents from an inventory.
    /// - Parameter expression: Inventory.
    /// - Returns: Supply with the contents of the inventory.
    public static func buildExpression<I: Inventory>(_ expression: I) -> Supply where I.Item == Item {
        .wrap(expression.contents)
    }
    /// Extracts contents from a stock.
    /// - Parameter expression: Stock.
    /// - Returns: Supply with the contents of the stock.
    public static func buildExpression(_ expression: Stock) -> Supply {
        .init([expression])
    }
    /// Extracts contents from an array of stock.
    /// - Parameter expression: Array of stocks.
    /// - Returns: Supply with the contents of the array of stocks.
    public static func buildExpression(_ expression: [Stock]) -> Supply {
        .init(expression)
    }
    // MARK: 1-by-1
    /// Builds the first block.
    /// - Parameter first: Supply block.
    /// - Returns: Supply block.
    public static func buildPartialBlock(first: Supply) -> Supply {
        first
    }
    /// Builds a partial block.
    /// - Parameters:
    ///   - accumulated: Supply so far.
    ///   - next: Supply to add.
    ///
    /// - Returns: Supply with the combined contents of both supplies.
    public static func buildPartialBlock(accumulated: Supply, next: Supply) -> Supply {
        .init(accumulated.items + next.items)
    }
    // MARK: Sequence
    /// Builds a repeated list of supplies.
    /// - Parameter components: Sequence of supplies.
    /// - Returns: Supply with the combined contents of all supplies.
    public static func buildBlock(_ components: Supply...) -> Supply {
        .init(components.flatMap(\.items))
    }
    // MARK: if-else-switch
    /// Builds the first `if` block.
    /// - Parameter component: Component to be built.
    /// - Returns: Supply block.
    public static func buildEither(first component: Supply) -> Supply {
        component
    }
    /// Builds the `else` block.
    /// - Parameter component: Component to be built.
    /// - Returns: Supply block
    public static func buildEither(second component: Supply) -> Supply {
        component
    }
    /// Builds a standalone `if` block.
    /// - Parameter component: Component to be built.
    /// - Returns: Supply block.
    public static func buildOptional(_ component: Supply?) -> Supply {
        if let component { component } else { .init([]) }
    }
    // MARK: for-in
    /// Builds a sequence of blocks.
    /// - Parameter components: List of components obtained in the iteration.
    /// - Returns: Supply with the combined contents.
    public static func buildArray(_ components: [Supply]) -> Supply {
        .init(components.flatMap(\.items))
    }
    // MARK: Postprocessing
    /// Transforms the supply in an array of measurements.
    /// - Parameter component: Final supply.
    /// - Returns: Array of measurements.
    public static func buildFinalResult(_ component: Supply) -> [Measurement<Item, Tally>] {
        component.items
    }
    /// Transforms the supply in an inventory.
    /// - Parameter component: Final supply.
    /// - Returns: Inventory with the supply's contents.
    @_disfavoredOverload
    public static func buildFinalResult<I: Inventory>(_ component: Supply) -> I where Item == I.Item {
        .init(component.items)
    }
    // MARK: Type Erasure
    /// Builds an `#available` block.
    /// - Parameter component: Supply to be erased.
    /// - Returns: Supply block.
    public static func buildLimitedAvailability(_ component: Supply) -> Supply {
        component
    }
}

// MARK: Self.Stock
public extension ItemBuilder {
    /// Measurement of stock for a given item.
    typealias Stock = Measurement<Item, Tally>
}

// MARK: Self.Supply
public extension ItemBuilder {
    /// Building block for describing a list of items declaratively.
    struct Supply {
        /// List of contents.
        var items: [Stock]
        /// Creates a new supply.
        /// - Parameter items: List of contents.
        public init(_ items: [Stock]) { self.items = items }
        /// Creates a supply from a collection of stock.
        /// - Parameter sequence: Sequence of stocks.
        /// - Returns: Supply block.
        static func wrap(_ sequence: some Sequence<Stock>) -> Self {
            .init(sequence.map(\.self))
        }
    }
}

extension ItemBuilder.Supply: Equatable where Item: Equatable {}
extension ItemBuilder.Supply: Sendable where Item: Sendable {}

// MARK: Self.Item: Measurable
public extension ItemBuilder where Item: Quantifiable {
    /// Transforms an item into a supply.
    /// - Parameter expression: Item to be referenced.
    /// - Returns: Supply with a single item.
    static func buildExpression(_ expression: Item) -> Supply {
        .init([expression.x(1)])
    }
}
