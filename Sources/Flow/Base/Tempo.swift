//
//  Tempo.swift
//  Trinkets
//
//  Created by Martônio Júnior on 22/07/2025.
//

import Foundation
import Mathe
/// Unitless multiplier for defining a relative pacing for updates in a game.
/// - Value: Type representing the multiplier.
/// 
/// Works as an unitless multiplier that can be used to provide control over the pacing,
/// being able to define progress, backtracking or stability. This can amplify, reduce,
/// halt or even invert how updates work in a game.
public struct Tempo<Value: Numeric & Comparable> {
    // MARK: Variables
    /// Multiplier representing the pacing of updates.
    var multiplier: Value
    // MARK: Initializers
    /// Creates a tempo from a multiplier.
    /// - Parameter multiplier: Multiplier representing the pacing of updates.
    public init(_ multiplier: Value) {
        self.multiplier = multiplier
    }
}

// MARK: Operators
public extension Tempo {
    /// Multiplies a value for a given tempo.
    /// - Parameters:
    ///   - lhs: Value to be multiplied.
    ///   - rhs: Tempo multiplier.
    ///
    /// - Returns: Multiplied value.
    static func * (lhs: Value, rhs: Self) -> Value {
        lhs * rhs.multiplier
    }
    /// Multiplies tempo by a given value.
    /// - Parameters:
    ///   - lhs: Tempo to be multiplied.
    ///   - factor: Value multiplier.
    ///
    /// - Returns: Multiplied tempo.
    static func * (lhs: Self, factor: Value) -> Self {
        .init(lhs.multiplier * factor)
    }
    /// Multiplies two tempos together.
    /// - Parameters:
    ///   - lhs: A tempo.
    ///   - rhs: Another tempo.
    ///
    /// - Returns: Tempo with the product of multipliers.
    static func * (lhs: Self, rhs: Self) -> Self {
        .init(lhs.multiplier * rhs.multiplier)
    }
}

// MARK: DotSyntax
public extension Tempo {
    /// Defines a forward (1x) pace.
    static var forward: Self { .init(1) }
    /// Defines a paused (0x) pace where updates do not happen.
    static var halt: Self { .init(0) }
    /// Defines a hastened pace based on a given sort order and multiplier.
    /// - Parameters:
    ///   - multiplier: Multiplier applied to sort order.
    ///
    /// - Returns: Tempo with a specified multiplier in a given direction.
    /// 
    /// Note: `multiplier` is clamped to always be one or greater without affecting the sign.
    static func fastForward(x multiplier: Value = 2) -> Self {
        .init((1...).floor(multiplier))
    }
}

// MARK: Self: AdditiveArithmetic
extension Tempo: AdditiveArithmetic {
    /// Adds two tempos together.
    /// - Parameters:
    ///   - lhs: A tempo,
    ///   - rhs: Another tempo.
    ///
    /// - Returns: Tempo with the sum of multipliers.
    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(lhs.multiplier + rhs.multiplier)
    }
    /// Subtracts a tempo from another tempo.
    /// - Parameters:
    ///   - lhs: lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    ///
    /// - Returns: Tempo with the difference of multipliers.
    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(lhs.multiplier - rhs.multiplier)
    }
}

// MARK: Self: Codable
extension Tempo: Codable where Value: Codable {}

// MARK: Self: Comparable
extension Tempo: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.multiplier < rhs.multiplier
    }
}

// MARK: Self: Equatable
extension Tempo: Equatable {}

// MARK: Self: ExpressibleByIntegerLiteral
extension Tempo: ExpressibleByIntegerLiteral {
    // swiftlint:disable:next missing_docs
    public init(integerLiteral value: Value.IntegerLiteralType) {
        multiplier = .init(integerLiteral: value)
    }
}

// MARK: Self: ExpressibleByFloatLiteral
extension Tempo: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
    // swiftlint:disable:next missing_docs
    public init(floatLiteral value: Value.FloatLiteralType) {
        multiplier = .init(floatLiteral: value)
    }
}

// MARK: Self: Hashable
extension Tempo: Hashable where Value: Hashable {}

// MARK: Self: Sendable
extension Tempo: Sendable where Value: Sendable {}

// MARK: Self.Value: FloatingPoint
public extension Tempo where Value: FloatingPoint {
    /// Divides tempo by a given factor.
    /// - Parameters:
    ///   - lhs: Tempo to be divided.
    ///   - factor: Value to divide `lhs` by.
    ///
    /// - Returns: Tempo with multiplier divided by a factor.
    static func / (lhs: Self, factor: Value) -> Self {
        .init(lhs.multiplier / factor)
    }
    /// Divides a tempo by another.
    /// - Parameters:
    ///   - lhs: Tempo to be divided.
    ///   - rhs: Tempo to divide `lhs` by.
    ///
    /// - Returns: Tempo with the division of multipliers.
    static func / (lhs: Self, rhs: Self) -> Self {
        .init(lhs.multiplier / rhs.multiplier)
    }
    /// Defines tempo by a slowdown factor.
    /// - Parameters:
    ///   - sortOrder: Direction of pace.
    ///   - factor: Slowdown factor.
    ///
    /// - Returns: Tempo slowed down by `factor` in a given pace direction.
    static func slow(_ sortOrder: SortOrder, by factor: Value) -> Self {
        .init(sortOrder) / factor
    }
}

// MARK: Self.Value: SignedNumeric
public extension Tempo where Value: SignedNumeric {
    /// Defines a backward (-1x) pace.
    static var reverse: Self { .init(-1) }
    /// Defines a rewind (-2x) pace.
    static var rewind: Self { .init(-2) }
    /// Creates a tempo from a given sort order.
    /// - Parameter sortOrder: Sort order used as the basis.
    init(_ sortOrder: SortOrder) {
        self = switch sortOrder {
            case .forward: .forward
            case .reverse: .reverse
        }
    }
    /// Defines a hastened pace based on a given sort order and multiplier.
    /// - Parameters:
    ///   - sortOrder: Direction of pace.
    ///   - multiplier: Multiplier applied to sort order.
    ///
    /// - Returns: Tempo with a specified multiplier in a given direction.
    /// 
    /// Note: `multiplier` is clamped to always be one or greater without affecting the sign.
    static func fast(_ sortOrder: SortOrder, x multiplier: Value = 2) -> Self {
        .init(sortOrder) * (1...).floor(multiplier)
    }
    /// Defines a reverse pace based on a given multiplier.
    /// - Parameter multiplier: Multiplier of pace.
    /// - Returns: Tempo reversed by a given multiplier.
    /// 
    /// Equivalent to the `.fast(.reverse, x:)` static method.
    /// 
    /// Note: `multiplier` is clamped to always be one or greater.
    static func rewind(x multiplier: Value) -> Self {
        .init(-1 * (1...).floor(multiplier))
    }
}

// MARK: Sequence (EX)
public extension Sequence {
    /// Creates an array that resizes the given sequence of elements.
    /// - Parameter tempo: Multiplier used to rescale the sequence.
    /// - Returns: Array with the elements appearing N times.
    func resize(in tempo: Tempo<UInt>) -> [Element] {
        flatMap { repeatElement($0, count: Int(tempo.multiplier)) }
    }
}

// MARK: Strideable (EX)
public extension Strideable {
    /// Applies a pacing transformation to the advancing value.
    /// - Parameters:
    ///   - n: Amount of value to jump based on this given tempo.
    ///   - tempo: Pace of the jump.
    /// - Returns: Value advanced by `n` multiplied by `tempo`.
    func advanced(by n: Stride = 1, in tempo: Tempo<Stride>) -> Self { advanced(by: n * tempo.multiplier) }
    /// Returns a value that is offset in the reverse pace.
    /// - Parameter n: Distance to backtrack this value.
    /// - Returns: Value offset by a given amount.
    func backtracked(by n: UInt) -> Self where Stride == Int {
        advanced(by: Int(n), in: .reverse)
    }
}
