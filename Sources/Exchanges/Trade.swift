//
//  Trade.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/07/2025.
//

/// Exchange performed between two entities, usually a buyer and a seller.
/// - A: Purchaser of goods.
/// - B: Seller of goods.
/// 
/// Example:
/// ```swift
/// Trade {
///   Exchange {
///     27 * ironNuggets
///   } for: {
///     3 * ironBlocks
///   }
/// } seller: {
///   Exchange {
///     1 * woodBlock
///   } for: {
///     4 * woodPlanks
///   }
/// }
/// ```
public struct Trade<A: Trader, B: Trader> where A.Buy == B.Sell, B.Buy == A.Sell {
    // MARK: Variables
    /// Exchange for the purchaser.
    var buyer: ExchangeFor<A>
    /// Exchange for the seller.
    var seller: ExchangeFor<B>
    // MARK: Initializers
    /// Creates a new trade between traders.
    /// - Parameters:
    ///   - buyer: Exchange for the purchaser.
    ///   - seller: Exchange for the seller.
    ///
    public init(_ buyer: ExchangeFor<A>, to seller: ExchangeFor<B>) {
        self.buyer = buyer
        self.seller = seller
    }
    // MARK: Methods
    /// Drains resources from purchaser to seller.
    /// - Parameters:
    ///   - purchaser: Purchaser of goods.
    ///   - supplier: Supplier of goods.
    ///
    /// - Returns: Remainder of the operation.
    public func drain(from purchaser: inout A?, to supplier: inout B) -> (buyer: A.Sell?, seller: B.Buy?) {
        let buyerRemainder = buyer.drain.apply(to: &purchaser)
        let sellerRemainder = seller.tap.apply(to: &supplier)

        return (buyerRemainder, sellerRemainder)
    }
    /// Taps resources into purchaser using seller as the source.
    /// - Parameters:
    ///   - purchaser: Purchaser of goods.
    ///   - supplier: Supplier of goods.
    ///
    /// - Returns: Remainder of the operation.
    public func tap(_ purchaser: inout A, using supplier: inout B?) -> (buyer: A.Buy?, seller: B.Sell?) {
        let sellerRemainder = seller.drain.apply(to: &supplier)
        let buyerRemainder = buyer.tap.apply(to: &purchaser)

        return (buyerRemainder, sellerRemainder)
    }
    /// Trades resources between purchaser and supplier.
    /// - Parameters:
    ///   - purchaser: Purchaser of goods.
    ///   - supplier: Supplier of goods.
    ///
    /// - Returns: Remainder of the operation.
    public func trade(between purchaser: inout A, and supplier: inout B) -> Remainder? {
        let buyerRemainder = buyer.apply(to: &purchaser)
        let sellerRemainder = seller.apply(to: &supplier)

        return .init(buyerRemainder, seller: sellerRemainder)
    }
}

// MARK: Self.Remainder
public extension Trade {
    /// Remainder of a trade operation.
    struct Remainder {
        var buyer: ExchangeFor<A>.Remainder
        var seller: ExchangeFor<B>.Remainder?
    }
}

public extension Trade.Remainder {
    /// Creates a trade remainder from the exchange remainders.
    /// - Parameters:
    ///   - buyer: Remainder from the buyer's exchange.
    ///   - seller: Remainder from the seller's exchange.
    ///
    init?(_ buyer: ExchangeFor<A>.Remainder?, seller: ExchangeFor<B>.Remainder?) {
        guard let buyer else { return nil }

        self.buyer = buyer
        self.seller = seller
    }
}

extension Trade.Remainder: Equatable where A: Equatable, B: Equatable, A.Buy: Equatable, A.Sell: Equatable {}
extension Trade.Remainder: Sendable where A: Sendable, B: Sendable, A.Buy: Sendable, A.Sell: Sendable {}

// MARK: Self: Equatable
extension Trade: Equatable where A: Equatable, B: Equatable, A.Buy: Equatable, A.Sell: Equatable {}

// MARK: Self: Sendable
extension Trade: Sendable where A: Sendable, B: Sendable, A.Buy: Sendable, A.Sell: Sendable {}

// MARK: A.Buy == A.Sell
public extension Trade where A.Buy == A.Sell {
    /// Swaps the contents managed by buyer and seller:
    /// - Buyer now performs the seller's exchange.
    /// - Seller now performs the buyer's exchange.
    var reversed: Trade<B, A> {
        .init(seller, to: buyer)
    }
}

// MARK: A == B
public extension Trade where A == B {
    /// Creates a trade by mapping out an exchange.
    /// - Parameters:
    ///   - exchange: Base exchange, used by the buyer.
    ///   - purchases: Mapper for purchases.
    ///   - supplies: Mapper for sales.
    ///
    init(
        _ exchange: ExchangeFor<A>,
        receives purchases: (A.Buy) -> A.Buy,
        offers supplies: (A.Sell) -> A.Sell
    ) {
        self.buyer = exchange
        self.seller = exchange.map(purchases, for: supplies)
    }
    /// Creates a trade from a single exchange.
    /// 
    /// This is achieved by flipping it for the seller.
    /// - Parameter exchange: Exchange used as the base.
    /// - Returns: New trade.
    /// 
    /// Example:
    /// ```swift
    /// let trade: Trade = .flow {
    ///   Exchange {
    ///     50 * leatherPieces
    ///   } for: {
    ///     20 * goldenApples
    ///   }
    /// }
    /// ```
    static func flow(_ exchange: ExchangeFor<A>) -> Self {
        .init(exchange, to: exchange.flipped)
    }
}
