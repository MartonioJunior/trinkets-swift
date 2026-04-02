//
//  Exchanger.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/09/2025.
//

public protocol Trader<Buy, Sell> {
    /// What the trader can receive
    associatedtype Buy
    /// What the trader can give
    associatedtype Sell

    mutating func buy(_ contents: Buy) -> Buy?
    mutating func sell(_ contents: Sell) -> Sell?
}

// MARK: Default Implementation
public extension Trader {
    mutating func buyMany(_ contents: some Sequence<Buy>) -> [Buy] {
        contents.compactMap { buy($0) }
    }

    mutating func sellMany(_ contents: some Sequence<Sell>) -> [Sell] {
        contents.compactMap { sell($0) }
    }
}

// MARK: Self.Input == Never
public extension Trader where Buy == Never {
    mutating func buy(_: Buy) -> Buy? {}
}

// MARK: Self.Output == Never
public extension Trader where Sell == Never {
    mutating func sell(_: Sell) -> Sell? {}
}

// MARK: Exchange (EX)
public extension Exchange where Target: Trader & SendableMetatype, Target.Buy == Buy, Target.Sell == Sell {
    static func buy(_ purchase: Buy, for price: Sell) -> Self {
        .buy {
            Tap(purchase) { $0.buy($1) }
        } for: {
            Drain(price) { $0?.sell($1) }
        }
    }
}
