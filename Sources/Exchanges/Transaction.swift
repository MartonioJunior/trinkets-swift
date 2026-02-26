//
//  Transaction.swift
//  Trinkets
//
//  Created by Martônio Júnior on 26/09/2025.
//

import Custom

public typealias Drain<Target, Contents> = Transaction<Target?, Contents>
public typealias Tap<Target, Contents> = Transaction<Target, Contents>

public struct Transaction<Target, Contents> {
    let apply: @Sendable (inout Target, Contents) -> Contents?
    let contents: Contents

    // MARK: Initializers
    public init(
        _ contents: @autoclosure () -> Contents,
        apply: @escaping @Sendable (inout Target, Contents) -> Contents?
    ) {
        self.contents = contents()
        self.apply = apply
    }

    // MARK: Methods
    public func map(_ transform: (Contents) -> Contents) -> Self {
        .init(transform(contents), apply: apply)
    }
}

// MARK: DotSyntax
public extension Transaction {
    static func noop(_ contents: Contents) -> Self {
        .init(contents) { _, contents in contents }
    }

    static func nullify(_ contents: Contents) -> Self {
        .init(contents) { _, _ in nil }
    }
}

// MARK: Self: Comparable
extension Transaction: Comparable where Contents: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.contents < rhs.contents
    }
}

// MARK: Self: Equatable
extension Transaction: Equatable where Contents: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.contents == rhs.contents
    }
}

// MARK: Self: Modifier
extension Transaction: Modifier {
    public func apply(to target: inout Target) -> Contents? {
        apply(&target, contents)
    }
}

// MARK: Self: Sendable
extension Transaction: Sendable where Target: Sendable, Contents: Sendable {}
