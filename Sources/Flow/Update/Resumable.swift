//
//  Resumable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/04/2026.
//

/// Component that can have it's execution resumed.
public protocol Resumable {
    /// Resumes the current execution.
    mutating func resume()
}
