//
//  Converter.swift
//  Trinkets
//
//  Created by Martônio Júnior on 29/08/2025.
//

/// Converter that defines a transformation between static measures.
public struct StaticConverter<Origin, Target, Value> {
    // MARK: Variables
    var f: (Value) -> Value
    // MARK: Initializers
    /// Creates a new static converter
    /// - Parameter f: Based on the unit transformation.
    public init(_ f: @escaping (Value) -> Value) {
        self.f = f
    }
    /// Creates a new static converter from the combination of two converters using base value as an intermediary.
    /// - Parameters:
    ///   - origin: Static converter from the origin to the base value.
    ///   - target: Static converter from the base value to the target.
    ///
    public init(
        _ origin: StaticConverter<Origin, Origin.Base, Value>,
        _ target: StaticConverter<Target.Base, Target, Value>,
    ) where Origin: StaticUnit, Target: StaticUnit, Origin.Base == Target.Base {
        self.init { target.f(origin.f($0)) }
    }
    // MARK: Methods
    /// Maps a converter based on another.
    /// - Parameter converter: Converter to transform the current one's output.
    /// - Returns: A new `StaticConverter` with the transformed output.
    public func mapOutput<T>(_ converter: StaticConverter<Target, T, Value>) -> StaticConverter<Origin, T, Value> {
        .init { converter.f(f($0)) }
    }
}

// MARK: Self: Sendable
extension StaticConverter: @unchecked Sendable {}
