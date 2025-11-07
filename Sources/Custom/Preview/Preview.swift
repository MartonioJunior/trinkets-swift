//
//  Preview.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

public typealias PreviewFor<M: Modifier> = Preview<M.Target, M.Output>

public struct Preview<Target, Output> {
    // MARK: Variables
    var target: Target
    var output: Output

    // MARK: Initializer
    public init(_ target: Target, output: Output) {
        self.target = target
        self.output = output
    }
}

// MARK: Self: Equatable
extension Preview: Equatable where Target: Equatable, Output: Equatable {}

// MARK: Self: Sendable
extension Preview: Sendable where Target: Sendable, Output: Sendable {}

// MARK: Modifier (EX)
public extension Modifier {
    func apply(
        to target: inout Target,
        predicate: (PreviewFor<Self>) -> Bool
    ) -> Output? {
        let preview = preview(on: target)

        guard predicate(preview) else { return nil }

        target = preview.target
        return preview.output
    }

    func preview(on source: Target) -> PreviewFor<Self> {
        var source = source
        let output = apply(to: &source)
        return .init(source, output: output)
    }
}

public extension Sequence where Element: Modifier {
    func preview(on target: Element.Target) -> Element.Target {
        reduce(target) {
            $1.preview(on: $0).target
        }
    }
}
