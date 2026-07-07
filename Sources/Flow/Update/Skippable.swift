//
//  Skippable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 06/07/2026.
//

/// Component that can skip iteration cycles.
public protocol Skippable {
    /// Behaviour of execution for this type.
    var playback: Playback { get set }
    /// Jumps to the next iteration cycle.
    mutating func skip()
}
