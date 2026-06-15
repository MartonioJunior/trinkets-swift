//
//  Modify.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

/// Concrete implementation of a modifier.
/// 
/// This allows you to create modifiers as instances through a closure.
/// 
/// Example:
/// ```swift
/// let recurvedClaw = Modify {
///   $0.sprintPower += 1
/// }
/// ```
public struct Modify<Target, Output> {
    // MARK: Variables
    /// Function applied to a target.
    var setter: (inout Target) -> Output
    // MARK: Initializers
    /// Creates a new modifier from a closure.
    /// - Parameter setter: Function applied to a target.
    public init(_ setter: @escaping (inout Target) -> Output) {
        self.setter = setter
    }
    /// Creates a new `Modify` from another modifier.
    /// - Parameter modifier: Modifier to be erased.
    public init<M: Modifier>(_ modifier: M) where Target == M.Target, Output == M.Output {
        self.init(modifier.apply)
    }
}

// MARK: DotSyntax
public extension Modify {
    /// Creates a modifier that mutates a property on the target.
    /// - Parameters:
    ///   - property: Property to be changed.
    ///   - modifier: Function that mutates a property.
    ///
    /// - Returns: A new modifier instance.
    static func customize<T>(
        _ property: WritableKeyPath<Target, T>,
        modifier: @escaping (inout T) -> Output
    ) -> Self {
        .init { modifier(&$0[keyPath: property]) }
    }
    /// Creates a modifier that replaces the value in a property.
    /// - Parameters:
    ///   - property: Property to be changed.
    ///   - newValue: Value to be set.
    ///
    /// - Returns: A new modifier instance.
    static func replace(
        _ property: WritableKeyPath<Target, Output>,
        with newValue: @autoclosure @escaping () -> Output
    ) -> Self {
        .customize(property) {
            let oldValue = $0
            $0 = newValue()
            return oldValue
        }
    }
}

// MARK: Self: Modifier
extension Modify: Modifier {
    // swiftlint:disable:next missing_docs
    public func apply(to target: inout Target) -> Output {
        setter(&target)
    }
}

// MARK: Self.Output == Void
public extension Modify where Output == Void {
    /// Creates a modifier that sets a property to `nil``.
    /// - Parameter property: Property to be changed.
    /// - Returns: A new modifier instance.
    static func clear<N>(_ property: WritableKeyPath<Target, N?>) -> Self {
        .set(property, to: nil)
    }
    /// Creates a modifier that sets a property with a new value.
    /// - Parameters:
    ///   - property: Property to be changed.
    ///   - newValue: Value to be set to.
    ///
    /// - Returns: A new modifier instance.
    static func set<N>(_ property: WritableKeyPath<Target, N>, to newValue: N) -> Self {
        .init { $0[keyPath: property] = newValue }
    }
    /// Creates a modifier that transforms the property's value with a map function.
    /// - Parameters:
    ///   - property: Property to be changed.
    ///   - map: Transformation function.
    ///
    /// - Returns: A new modifier instance.
    static func transform<N>(
        _ property: WritableKeyPath<Target, N>,
        map: @escaping (N) -> N
    ) -> Self {
        .init {
            let oldValue = $0[keyPath: property]
            $0[keyPath: property] = map(oldValue)
        }
    }
}

// MARK: Modifier (EX)
public extension Modifier {
    /// Version of the modifier to be operated on optional values that discards it's output.
    var forSlot: Modify<Target?, Void> { optional.noOutput }
    /// Version of the modifier that does not return an output for the operation.
    var noOutput: Modify<Target, Void> { .init { _ = apply(to: &$0) } }
    /// Version of the modifier to be operated on optional values
    var optional: Modify<Target?, Output?> {
        .init {
            guard var value = $0 else { return nil }

            let result = apply(to: &value)
            $0 = value
            return result
        }
    }
    /// Creates a modifier that does nothing.
    ///
    /// - Returns: Empty modifier.
    static func noop<T>() -> Self where Self == Modify<T, Void> {
        Modify { _ in }
    }
    /// Creates a modifier that does nothing and returns a `nil` result.
    ///
    /// - Returns: Empty modifier.
    static func noop<T, O>() -> Self where Self == Modify<T, O?> {
        Modify { _ in nil }
    }
}
