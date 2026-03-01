//
//  Controllable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 18/10/2025.
//

/// Component that can be controlled by issuing commands.
/// 
/// Example:
/// ```swift
/// extension Dinosaur: Controllable {
///   enum Command {
///     case move(BoardSpace)
///     case jump(BoardSpace)
///     case sniff
///     case sprint(Human)
///   }
/// }
///
/// let dinosaur = Dinosaur()
/// dinosaur.perform(.move(space32)) // true
/// dinosaur.perform(.sniff) // false, weather is raining
/// ```
public protocol Controllable {
    /// Possible order that can be received by the component.
    associatedtype Command
    /// Receives the request to perform a command.
    /// - Parameter command: Requested command.
    /// - Returns:
    ///   - `true` when the command was accepted and will be attempted.
    ///   - `false` when the command is rejected.
    mutating func perform(_ command: Command) -> Bool
}
