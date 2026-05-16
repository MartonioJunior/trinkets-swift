//
//  Formattable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/02/2026.
//

import Foundation

/// Protocol that allows a value to be formatted based on a given format style.
public protocol Formattable {
    /// Formats the object into a given style.
    /// - Parameter format: Format style to be used.
    /// - Returns: Output of the formatting operation.
    func formatted<S: FormatStyle>(_ format: S) -> S.FormatOutput where S.FormatInput == Self
}

// MARK: Default Implementation
public extension Formattable {
    // swiftlint:disable:next missing_docs
    func formatted<S: FormatStyle>(_ format: S) -> S.FormatOutput where S.FormatInput == Self {
        format.format(self)
    }
}
