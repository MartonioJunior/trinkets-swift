//
//  Pausable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/04/2026.
//

/// Component that can have it's execution paused.
public protocol Pausable {
    /// Pauses the current execution.
    mutating func pause()
}
