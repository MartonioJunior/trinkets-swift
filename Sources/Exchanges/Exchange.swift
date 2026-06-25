//
//  Exchange.swift
//  Trinkets
//
//  Created by Martônio Júnior on 14/07/2025.
//

import Custom
/// Exchange performed by a trader.
public typealias ExchangeFor<T: Trader> = Exchange<T, T.Buy, T.Sell>
/// Transaction that exchanges contents for a target.
/// - Target: Target of this operation.
/// - Buy: Contents to be removed from the target.
/// - Sell: Contents to be added to the target.
/// 
/// Example:
/// ```swift
/// Exchange {
///   Currency.of(1500, .gil)
/// } for: {
///   Potion(.super, plus: .hp)
/// }
/// ```
public struct Exchange<Target, Buy, Sell> {
    // MARK: Variables
    /// Operation that removes elements from the target.
    var drain: Drain<Target, Sell>
    /// Operation that adds elements to the target.
    var tap: Tap<Target, Buy>
    // MARK: Initializers
    /// Creates a new exchange for a target type.
    /// - Parameters:
    ///   - drain: Operation that removes elements from the target.
    ///   - tap: Operation that adds elements to the target.
    ///
    public init(drain: Drain<Target, Sell>, tap: Tap<Target, Buy>) {
        self.drain = drain
        self.tap = tap
    }
    /// Creates a new exchange for a target.
    /// - Parameters:
    ///   - purchase: Tap for the target.
    ///   - price: Drain for the target.
    ///
    public init(
        _ purchase: () -> Tap<Target, Buy>,
        for price: () -> Drain<Target, Sell>
    ) {
        self.init(drain: price(), tap: purchase())
    }
    // MARK: Methods
    /// Drains a given target.
    /// - Parameter target: Target to be drained.
    /// - Returns: Contents that were not drained from the target.
    @_disfavoredOverload
    public func drain(_ target: inout Target) -> Sell? {
        drain.apply(to: &target)
    }
    /// Transforms the contents of the exchange.
    /// - Parameters:
    ///   - purchase: Function transforming the contents to be added.
    ///   - price: Function transforming the contents to be removed.
    ///
    /// - Returns: New exchange with the transformed contents.
    public func map(
        _ purchase: (Buy) -> Buy,
        for price: (Sell) -> Sell
    ) -> Self {
        .init(drain: drain.map(price), tap: tap.map(purchase))
    }
    /// Taps a given target.
    /// - Parameter target: Target to be tapped.
    /// - Returns: Contents that were not tapped into the target.
    public func tap(_ target: inout Target) -> Buy? {
        tap.apply(to: &target)
    }
}

// MARK: Self.Remainder
public extension Exchange {
    /// Remainder of an exchange operation.
    struct Remainder {
        var buy: Buy
        var sell: Sell?
    }
}

// MARK: Self: Comparable
extension Exchange: Comparable where Buy: Comparable, Sell: Comparable {
    // swiftlint:disable:next missing_docs
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
    // swiftlint:disable:next missing_docs
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.tap == rhs.tap && lhs.drain == rhs.drain
    }
}

// MARK: Self: Modifier
extension Exchange: Modifier {
    // swiftlint:disable:next missing_docs
    public func apply(to target: inout Target) -> Remainder? {
        let drainResult = drain.preview(on: target)

        guard drainResult.output == nil else {
            return .init(buy: tap.contents, sell: drain.contents)
        }

        let drainedTarget = drainResult.target
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
    /// Flips the contents of the exchange around:
    /// - What is removed will now be added.
    /// - What is added will now be removed.
    var flipped: Exchange<Target, Sell, Buy> {
        .init(drain: .init(tap.contents, apply: drain.apply), tap: .init(drain.contents, apply: tap.apply))
    }
    /// Creates a drain-only exchange.
    /// - Parameter make: Creates the drain used in this exchange.
    /// - Returns: New exchange.
    static func drain(
        _ make: @autoclosure () -> Drain<Target, Sell>
    ) -> Self {
        let transaction = make()
        return .init(drain: transaction, tap: .noop(transaction.contents))
    }
    /// Creates a tap-only exchange.
    /// - Parameter make: Creates the tap used in this exchange.
    /// - Returns: New exchange.
    static func tap(
        _ make: @autoclosure () -> Transaction<Target, Buy>
    ) -> Self {
        let transaction = make()
        return .init(drain: .noop(transaction.contents), tap: transaction)
    }
}

// MARK: Self.Target: Optional
public extension Exchange {
    /// Drains a given target.
    /// - Parameter target: Target to be drained.
    /// - Returns: Contents that were not drained from the target.
    func drain<T>(unwrapped target: inout T) -> Sell? where Target == T? {
        guard let remainder = drain.apply(unwrapped: &target) else { return nil }

        return remainder
    }
}

// MARK: Transaction (EX)
public extension Transaction {
    /// Creates an exchange by combining a drain with a tap
    /// - Parameters:
    ///   - lhs: Drain of the exchange.
    ///   - rhs: Tap of the exchange.
    ///
    /// - Returns: New exchange.
    static func | <T>(lhs: Drain<Target, T>, rhs: Tap<Target, Contents>) -> Exchange<Target, Contents, T> {
        .init(drain: lhs, tap: rhs)
    }
}
