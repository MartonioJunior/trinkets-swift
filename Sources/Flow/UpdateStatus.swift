//
//  UpdateStatus.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/10/2025.
//

public enum UpdateStatus {
    /// Ready for updates, but not currently updating.
    case idle
    /// It is currently updating it's state.
    case running
    /// It is temporarily not applying updates.
    case paused
}

// MARK: Self: Equatable
extension UpdateStatus: Equatable {}

// MARK: Self: Sendable
extension UpdateStatus: Sendable {}
