//
//  Tagged+Measurable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/06/2026.
//

import Tagged

extension Tagged: Measurable where Tag: StaticUnit {
    // swiftlint:disable:next missing_docs
    public typealias Unit = Tag
    // swiftlint:disable:next missing_docs
    public typealias Quantity = RawValue
    // swiftlint:disable:next missing_docs
    public var quantity: RawValue { rawValue }
}
