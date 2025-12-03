//
//  Modifier.swift
//  Trinkets
//
//  Created by Martônio Júnior on 19/10/2025.
//

public protocol Modifier<Target, Output> {
    associatedtype Target
    associatedtype Output = Void

    func apply(to target: inout Target) -> Output
}

// MARK: Modifier.Target: Optional
public extension Modifier {
    func apply<T>(toWrapped target: inout T) -> Output? where Target == T? {
        let result = preview(on: target)

        if let newTarget = result.target {
            target = newTarget
            return result.output
        }

        return nil
    }
}

// MARK: Sequence (EX)
extension Sequence where Element: Modifier, Element.Output == Void {
    func apply(to target: inout Element.Target) {
        forEach { $0.apply(to: &target) }
    }
}
