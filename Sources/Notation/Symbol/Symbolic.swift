//
//  Symbolic.swift
//  Trinkets
//
//  Created by Martônio Júnior on 09/04/2026.
//

public protocol Symbolic<Context, LocalizedResource> {
    associatedtype Context
    associatedtype LocalizedResource

    func localized(for context: Context) -> LocalizedResource
}
