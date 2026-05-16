//
//  UnitRepresentation.swift
//  Trinkets
//
//  Created by Martônio Júnior on 09/04/2026.
//

import Foundation
import Notation

/// Defines how an unit should be handled in textual representations.
/// 
/// This includes:
/// - Differentiating between singular and plural forms.
/// - Defining the width of the representation.
public struct UnitRepresentation {
    // MARK: Variables
    /// Resource used to represent it's smallest representation.
    var symbol: LocalizedStringResource
    /// Name of the unit. It adapts to the quantity it's associated with.
    nonisolated(unsafe) var name: any Symbolic<Double, LocalizedStringResource>
    // MARK: Initializers
    /// Creates a new unit representation
    /// - Parameters:
    ///   - symbol:
    ///   - name:
    ///
    public init(
        symbol: LocalizedStringResource,
        name: @autoclosure () -> any Symbolic<Double, LocalizedStringResource>
    ) {
        self.symbol = symbol
        self.name = name()
    }
}

// MARK: DotSyntax
public extension UnitRepresentation {
    /// Creates an unit representation that only has a singular name
    /// - Parameters:
    ///   - symbol: Symbol for the unit.
    ///   - name: Name of the unit.
    ///
    /// - Returns: A new `UnitRepresentation`.
    static func nonPluralized(symbol: LocalizedStringResource, name: LocalizedStringResource) -> Self {
        .init(symbol: symbol, name: SyntaxMap(default: name))
    }
    /// Creates an unit representation with separate singular and plural names.
    /// - Parameters:
    ///   - symbol: Symbol for the unit.
    ///   - singular: Name of the unit in it's singular form.
    ///   - plural: Name of the unit in it's plural form.
    ///
    /// - Returns: A new `UnitRepresentation`.
    static func pluralized(
        symbol: LocalizedStringResource,
        singular: LocalizedStringResource,
        plural: LocalizedStringResource
    ) -> Self {
        .init(symbol: symbol, name: SyntaxMap.pluralized(singular: singular, plural: plural))
    }
    /// Creates an unit representation where it's name depends on the amount associated with it.
    /// - Parameters:
    ///   - symbol: Symbol for the unit.
    ///   - name: Function that returns the name for a given amount.
    ///
    /// - Returns: A new `UnitRepresentation`.
    static func quantified(
        symbol: LocalizedStringResource,
        name: @escaping @Sendable (Double) -> LocalizedStringResource
    ) -> Self {
        .init(symbol: symbol, name: SyntaxFunction(name))
    }
}

// MARK: Self.Width
extension UnitRepresentation {
    /// Data structure that defines the text width for the representation of an unit.
    public enum Width {
        /// Shortest possible form of representation, using only letters and/or symbols.
        case abbreviated
        /// Shows a sampled text with a select few defining letters.
        case narrow
        /// Shows the full name for the unit.
        case wide
    }
}

// MARK: Self: CustomStringConvertible
extension UnitRepresentation: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { .init(localized: symbol) }
}

// MARK: Self: Symbolic
extension UnitRepresentation: Symbolic {
    // swiftlint:disable:next missing_docs
    public struct Context {
        var amount: Double
        var width: Width
    }
    // swiftlint:disable:next missing_docs
    public func localized(for context: Context) -> LocalizedStringResource {
        switch context.width {
            case .abbreviated, .narrow: symbol
            case .wide: name.localized(for: context.amount)
        }
    }
}

// MARK: Self: Sendable
extension UnitRepresentation: Sendable {}
