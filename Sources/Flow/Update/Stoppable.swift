//
//  Stoppable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/04/2026.
//

/// Component that can have it's execution fully halted.
public protocol Stoppable {
    /// Stops the current execution.
    mutating func stop()
}
