//
//  SyntaxFunction.swift
//  Trinkets
//
//  Created by Martônio Júnior on 10/04/2026.
//

public struct SyntaxFunction<Input, Output> {
    // MARK: Variables
    var f: @Sendable (Input) -> Output

    // MARK: Initializers
    public init(_ f: @escaping @Sendable (Input) -> Output) {
        self.f = f
    }
}

// MARK: Self: Symbolic
extension SyntaxFunction: Symbolic {
    public func localized(for context: Input) -> Output { f(context) }
}

// MARK: Self: Sendable
extension SyntaxFunction: Sendable where Input: Sendable, Output: Sendable {}
