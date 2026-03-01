//
//  FlowStatus.swift
//  Trinkets
//
//  Created by Martônio Júnior on 28/10/2025.
//

public enum FlowStatus {
    /// Ready for updates, but not currently updating.
    case idle
    /// It is currently updating it's state.
    case running
    /// It is temporarily not applying updates.
    case paused
}

// MARK: Self: Equatable
extension FlowStatus: Equatable {}

// MARK: Self: Sendable
extension FlowStatus: Sendable {}
