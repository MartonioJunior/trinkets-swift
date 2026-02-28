//
//  CronographStatus.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/10/2025.
//

/// Enumerator that lists all possible states for a `Cronograph`.
public enum CronographStatus {
    /// Ready for updates, but not currently updating.
    case idle
    /// It is temporarily not applying updates.
    case paused
    /// It is currently updating it's state.
    case running
}

// MARK: Self: Equatable
extension CronographStatus: Equatable {}

// MARK: Self: Sendable
extension CronographStatus: Sendable {}
