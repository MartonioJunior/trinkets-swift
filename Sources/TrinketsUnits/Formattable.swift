//
//  Formattable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 24/02/2026.
//

import Foundation

public protocol Formattable {
    func formatted<S: FormatStyle>(_ format: S) -> S.FormatOutput where S.FormatInput == Self
}

// MARK: Default Implementation
public extension Formattable {
    func formatted<S: FormatStyle>(_ format: S) -> S.FormatOutput where S.FormatInput == Self {
        format.format(self)
    }
}
