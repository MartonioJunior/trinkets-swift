//
//  Modify.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

public struct Modify<Target, Output> {
    // MARK: Variables
    var setter: (inout Target) -> Output

    // MARK: Initializers
    public init(_ setter: @escaping (inout Target) -> Output) {
        self.setter = setter
    }

    public init<M: Modifier>(_ modifier: M) where Target == M.Target, Output == M.Output {
        self.init(modifier.apply)
    }
}

// MARK: DotSyntax
public extension Modify {
    static func customize<T>(
        _ attribute: WritableKeyPath<Target, T>,
        modifier: @escaping (inout T) -> Output
    ) -> Self {
        .init { modifier(&$0[keyPath: attribute]) }
    }

    static func replace(
        _ attribute: WritableKeyPath<Target, Output>,
        with newValue: @autoclosure @escaping () -> Output
    ) -> Self {
        .customize(attribute) {
            let oldValue = $0
            $0 = newValue()
            return oldValue
        }
    }
}

// MARK: Self: Modifier
extension Modify: Modifier {
    public func apply(to source: inout Target) -> Output {
        setter(&source)
    }
}

// MARK: Self.Output == Void
public extension Modify where Output == Void {
    static func clear<N>(_ attribute: WritableKeyPath<Target, N?>) -> Self {
        .set(attribute, to: nil)
    }
    /// Sets an attribute with a new value
    /// - Parameters:
    ///   - attribute: The attribute in the source to be modified
    ///   - newValue: The new value to be set to
    ///
    /// - Returns: A new modifier
    static func set<N>(_ attribute: WritableKeyPath<Target, N>, to newValue: N) -> Self {
        .init { $0[keyPath: attribute] = newValue }
    }

    static func transform<N>(_ attribute: WritableKeyPath<Target, N>, map: @escaping (N) -> N) -> Self {
        .init {
            let oldValue = $0[keyPath: attribute]
            $0[keyPath: attribute] = map(oldValue)
        }
    }
}

// MARK: Modifier (EX)
public extension Modifier {
    var forSlot: Modify<Target?, Void> { optional.noOutput }
    var noOutput: Modify<Target, Void> { .init { _ = apply(to: &$0) } }
    var optional: Modify<Target?, Output?> {
        .init {
            guard var value = $0 else { return nil }

            let result = apply(to: &value)
            $0 = value
            return result
        }
    }
}
