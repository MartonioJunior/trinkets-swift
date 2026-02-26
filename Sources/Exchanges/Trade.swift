//
//  Trade.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/07/2025.
//

public struct Trade<A: Trader, B: Trader> where A.Buy == B.Sell, B.Buy == A.Sell {
    // MARK: Variables
    var buyer: ExchangeFor<A>
    var seller: ExchangeFor<B>

    // MARK: Initializers
    public init(_ buyer: ExchangeFor<A>, to seller: ExchangeFor<B>) {
        self.buyer = buyer
        self.seller = seller
    }

    // MARK: Methods
    public func drain(from purchaser: inout A?, to supplier: inout B) -> (buyer: A.Sell?, seller: B.Buy?) {
        let buyerRemainder = buyer.drain.apply(to: &purchaser)
        let sellerRemainder = seller.tap.apply(to: &supplier)

        return (buyerRemainder, sellerRemainder)
    }

    public func tap(_ purchaser: inout A, using supplier: inout B?) -> (buyer: A.Buy?, seller: B.Sell?) {
        let sellerRemainder = seller.drain.apply(to: &supplier)
        let buyerRemainder = buyer.tap.apply(to: &purchaser)

        return (buyerRemainder, sellerRemainder)
    }

    public func trade(between purchaser: inout A, and supplier: inout B) -> Remainder? {
        let buyerRemainder = buyer.apply(to: &purchaser)
        let sellerRemainder = seller.apply(to: &supplier)

        return .init(buyerRemainder, seller: sellerRemainder)
    }
}

// MARK: Self.Remainder
public extension Trade {
    struct Remainder {
        var buyer: ExchangeFor<A>.Remainder
        var seller: ExchangeFor<B>.Remainder?
    }
}

public extension Trade.Remainder {
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
    var reversed: Trade<B, A> {
        .init(seller, to: buyer)
    }
}

// MARK: A == B
public extension Trade where A == B {
    static func flow(_ exchange: ExchangeFor<A>) -> Self {
        .init(exchange, to: exchange.flipped)
    }

    init(
        _ exchange: ExchangeFor<A>,
        receives purchases: (A.Buy) -> A.Buy,
        offers supplies: (A.Sell) -> A.Sell
    ) {
        self.buyer = exchange
        self.seller = exchange.map(purchases, for: supplies)
    }
}
