//
//  Exchange.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/07/2025.
//

import Custom

public typealias ExchangeFor<T: Trader> = Exchange<T, T.Buy, T.Sell>

public struct Exchange<Target, Buy, Sell> {
    // MARK: Variables
    var drain: Drain<Target, Sell>
    var tap: Tap<Target, Buy>

    // MARK: Initializers
    public init(drain: Drain<Target, Sell>, tap: Tap<Target, Buy>) {
        self.drain = drain
        self.tap = tap
    }

    // MARK: Methods
    @_disfavoredOverload
    public func drain(_ target: inout Target?) -> Sell? {
        drain.apply(to: &target)
    }

    public func drain(unwrapped target: inout Target) -> Sell? {
        guard let remainder = drain.apply(unwrapped: &target) else { return nil }

        return remainder
    }

    public func map(
        _ purchase: (Buy) -> Buy,
        for price: (Sell) -> Sell
    ) -> Self {
        .init(drain: drain.map(price), tap: tap.map(purchase))
    }

    public func tap(_ target: inout Target) -> Buy? {
        tap.apply(to: &target)
    }
}

// MARK: DotSyntax
public extension Exchange {
    static func buy(
        _ purchase: () -> Tap<Target, Buy>,
        for price: () -> Drain<Target, Sell>
    ) -> Self {
        .init(drain: price(), tap: purchase())
    }
}

// MARK: Self: Comparable
extension Exchange: Comparable where Buy: Comparable, Sell: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.drain == rhs.drain {
            lhs.tap < rhs.tap
        } else {
            lhs.drain < rhs.drain
        }
    }
}

// MARK: Self: Equatable
extension Exchange: Equatable where Buy: Equatable, Sell: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.tap == rhs.tap && lhs.drain == rhs.drain
    }
}

// MARK: Self: Modifier
extension Exchange: Modifier {
    public struct Remainder {
        var buy: Buy
        var sell: Sell?
    }

    public func apply(to target: inout Target) -> Remainder? {
        let drainResult = drain.preview(on: target)

        guard let drainedTarget = drainResult.target, drainResult.output == nil else {
            return .init(buy: tap.contents, sell: drain.contents)
        }

        let tapResult = tap.preview(on: drainedTarget)
        target = tapResult.target

        return if let tapRemainder = tapResult.output {
            .init(buy: tapRemainder)
        } else {
            nil
        }
    }
}

extension Exchange.Remainder: Equatable where Buy: Equatable, Sell: Equatable {}
extension Exchange.Remainder: Sendable where Buy: Sendable, Sell: Sendable {}

// MARK: Self: Sendable
extension Exchange: Sendable where Target: Sendable, Buy: Sendable, Sell: Sendable {}

// MARK: Self.Buy == Self.Sell
public extension Exchange where Buy == Sell {
    var flipped: Exchange<Target, Sell, Buy> {
        .init(drain: .init(tap.contents, apply: drain.apply), tap: .init(drain.contents, apply: tap.apply))
    }

    static func drain(
        _ make: @autoclosure () -> Transaction<Target?, Sell>
    ) -> Self {
        let transaction = make()
        return .init(drain: transaction, tap: .noop(transaction.contents))
    }

    static func tap(
        _ make: @autoclosure () -> Transaction<Target, Buy>
    ) -> Self {
        let transaction = make()
        return .init(drain: .noop(transaction.contents), tap: transaction)
    }
}

// MARK: Transaction (EX)
public extension Transaction {
    static func | <T>(lhs: Transaction<Target?, T>, rhs: Transaction<Target, Contents>) -> Exchange<Target, Contents, T> {
        .init(drain: lhs, tap: rhs)
    }
}
