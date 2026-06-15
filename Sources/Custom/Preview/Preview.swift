//
//  Preview.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

/// Alias of a preview for a given modifier.
public typealias PreviewFor<M: Modifier> = Preview<M.Target, M.Output>
/// Data structure showing the result of a modifier change.
/// 
/// Preview objects are used to show how objects are changed without altering the original value.
/// 
/// For classes, a deep copy needs to be made in order to avoid mutation on preview.
/// - Target: Structure to be modified.
/// - Output: Result of the modifier operation.
public struct Preview<Target, Output> {
    // MARK: Variables
    /// Target after being modified.
    public var target: Target
    /// Output of the modifier.
    public var output: Output
    // MARK: Initializer
    /// Creates a new preview for a target.
    /// - Parameters:
    ///   - target: Target after being modified.
    ///   - output: Output of the modifier.
    ///
    public init(_ target: Target, output: Output) {
        self.target = target
        self.output = output
    }
}

// MARK: Self: Equatable
extension Preview: Equatable where Target: Equatable, Output: Equatable {}

// MARK: Self: Sendable
extension Preview: Sendable where Target: Sendable, Output: Sendable {}

// MARK: Self.Output: ExpressibleByNilLiteral
public extension Preview where Output: ExpressibleByNilLiteral {
    /// Creates a preview for a target with a nil output.
    /// - Parameter target: Target of the preview.
    init(_ target: Target) {
        self.init(target, output: nil)
    }
}

// MARK: Modifier (EX)
public extension Modifier {
    /// Type that represents a preview for this modifier.
    typealias Previewed = PreviewFor<Self>
    /// Applies a modifier to a target after validating it's previewed output.
    /// - Parameters:
    ///   - target: Target to be modified.
    ///   - predicate: Predicate that validates the preview.
    ///
    /// - Returns: Output of the modification. If the predicate blocks changes, returns `nil`.
    /// 
    /// Example:
    /// ```swift
    /// recurvedClaw.apply(to: dinosaur) {
    ///   $0.target.needsGenomaFactor
    /// }
    /// ```
    func apply(
        to target: inout Target,
        predicate: (PreviewFor<Self>) -> Bool
    ) -> Output? {
        let preview = preview(on: target)

        guard predicate(preview) else { return nil }

        target = preview.target
        return preview.output
    }
    /// Previews the modifications on a target without altering it.
    /// - Parameter target: Target to be modified.
    /// - Returns: Preview of the changes to `target`.
    /// 
    /// Example:
    /// ```swift
    /// let previewDinosaur = recurvedClaw.preview(on: dinosaur)
    /// ```
    func preview(on target: Target) -> PreviewFor<Self> {
        var target = target
        let output = apply(to: &target)
        return .init(target, output: output)
    }
}

public extension Sequence where Element: Modifier {
    /// Previews the modifications on a target without altering it.
    ///
    /// Modifiers are applied in the order they come in the sequence. 
    /// - Parameter target: Target to be modified.
    /// - Returns: Preview of the changes to `target`.
    func preview(on target: Element.Target) -> Element.Target {
        reduce(target) {
            $1.preview(on: $0).target
        }
    }
}
