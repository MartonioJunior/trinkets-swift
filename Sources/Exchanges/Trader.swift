//
//  Exchanger.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/09/2025.
//

/// Exchanger of goods, who's capable of buying and/or selling items.
/// 
/// Use this protocol when making more complex exchanges where the target can
/// manage a supply of sorts.
public protocol Trader<Buy, Sell> {
    /// What the trader can receive
    associatedtype Buy
    /// What the trader can give
    associatedtype Sell
    /// Purchases contents from another source.
    /// - Parameter contents: Contents to be purchased.
    /// - Returns: Remainder of `contents` that wasn't assimilated upon purchase.
    mutating func buy(_ contents: Buy) -> Buy?
    /// Sells contents that it supplies.
    /// - Parameter contents: Contents to be sold.
    /// - Returns: Remainder of `contents` that can't be divested on a sale.
    mutating func sell(_ contents: Sell) -> Sell?
}

// MARK: Default Implementation
public extension Trader {
    /// Performs multiple purchases in a row.
    /// - Parameter contents: List of purchases.
    /// - Returns: Remainders of purchases.
    mutating func buyMany(_ contents: some Sequence<Buy>) -> [Buy] {
        contents.compactMap { buy($0) }
    }
    /// Performs multiple sales in a row.
    /// - Parameter contents: List of sales.
    /// - Returns: Remainders of sales.
    mutating func sellMany(_ contents: some Sequence<Sell>) -> [Sell] {
        contents.compactMap { sell($0) }
    }
}

// MARK: Self.Input == Never
public extension Trader where Buy == Never {
    // swiftlint:disable:next missing_docs
    mutating func buy(_: Buy) -> Buy? {}
}

// MARK: Self.Output == Never
public extension Trader where Sell == Never {
    // swiftlint:disable:next missing_docs
    mutating func sell(_: Sell) -> Sell? {}
}

// MARK: Exchange (EX)
public extension Exchange where Target: Trader & SendableMetatype, Target.Buy == Buy, Target.Sell == Sell {
    /// Defines an exchange for a trader that takes into account it's storage space and supply.
    /// 
    /// - Parameters:
    ///   - purchase: What will be purchased.
    ///   - price: What will be sold.
    ///
    /// - Returns:
    static func buy(_ purchase: Buy, for price: Sell) -> Self {
        Exchange {
            Tap(purchase) { $0.buy($1) }
        } for: {
            Drain(price) { $0.sell($1) }
        }
    }
}
