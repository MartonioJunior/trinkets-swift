//
//  Operational.swift
//  Trinkets
//
//  Created by Martônio Júnior on 01/03/2026.
//

/// Object that can have statuses modified over it's lifecycle.
/// 
/// Example:
/// ```swift
/// struct Machine: Operational {
///   enum Status {
///     case idle
///     case running
///     case paused
///   }
/// }
///
/// machine.status // Running...
/// ```
public protocol Operational {
    /// Type representing the status in the system.
    associatedtype Status
    /// Current stage of operation.
    var status: Status { get }
}
