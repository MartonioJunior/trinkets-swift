//
//  Transaction.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/09/2025.
//

import Custom
/// Transaction that removes resources from the economy.
public typealias Drain<Target, Contents> = Transaction<Target?, Contents>
/// Transaction that adds resources to the economy
public typealias Tap<Target, Contents> = Transaction<Target, Contents>
/// Modifier that changes the economy in a target.
/// - Target: Structure being modified.
/// - Contents: Information about the operation.
/// 
/// Example:
/// ```swift
/// let addFiveStrawberries = Transaction() {
///   5 * strawberries
/// } apply: {
///   $0.collect($1)
/// }
/// ```
public struct Transaction<Target, Contents> {
    /// Operation to be performed.
    let apply: @Sendable (inout Target, Contents) -> Contents?
    /// Contents of the transaction.
    let contents: Contents
    // MARK: Initializers
    /// Creates a new transaction.
    /// - Parameters:
    ///   - contents: Contents of the transaction.
    ///   - apply: Operation to be performed.
    ///
    public init(
        _ contents: @autoclosure () -> Contents,
        apply: @escaping @Sendable (inout Target, Contents) -> Contents?
    ) {
        self.contents = contents()
        self.apply = apply
    }
    // MARK: Methods
    /// Creates a new transaction by transforming it's contents.
    /// - Parameter transform: Function that transforms the content.
    /// - Returns: Transaction structure with transformed contents.
    /// 
    /// Example:
    /// ```swift
    /// let giveDoubleStrawberries = giveStrawberries.map { $0 * 2 }
    /// ```
    public func map(_ transform: (Contents) -> Contents) -> Self {
        .init(transform(contents), apply: apply)
    }
}

// MARK: DotSyntax
public extension Transaction {
    /// Transaction that can operate on optional targets.
    var optional: Transaction<Target?, Contents> {
        let operation = apply

        return .init(contents) {
            guard var target = $0 else { return nil }

            let result = operation(&target, $1)
            $0 = target
            return result
        }
    }
    /// Creates a transaction that does not mutate the target.
    /// - Parameter contents: Contents of the transaction
    /// - Returns: New transaction.
    static func noop(_ contents: Contents) -> Self {
        .init(contents) { _, contents in contents }
    }
    /// Creates a transaction that nullifies the target, no matter the contents.
    /// - Parameter contents: Contents of the transaction.
    /// - Returns: New transaction
    static func nullify(_ contents: Contents) -> Self {
        .init(contents) { _, _ in nil }
    }
}

// MARK: Self: Comparable
extension Transaction: Comparable where Contents: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.contents < rhs.contents
    }
}

// MARK: Self: Equatable
extension Transaction: Equatable where Contents: Equatable {
    // swiftlint:disable:next missing_docs
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.contents == rhs.contents
    }
}

// MARK: Self: Modifier
extension Transaction: Modifier {
    // swiftlint:disable:next missing_docs
    public func apply(to target: inout Target) -> Contents? {
        apply(&target, contents)
    }
}

// MARK: Self: Sendable
extension Transaction: Sendable where Target: Sendable, Contents: Sendable {}
