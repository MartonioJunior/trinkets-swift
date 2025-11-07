//
//  Customizable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/09/2025.
//

public protocol Customizable {
    associatedtype Modifiers: Collection where Modifiers.Element: Modifier

    typealias Target = Modifiers.Element.Target
    typealias Output = Modifiers.Element.Output

    var modifiers: Modifiers { get }
}

// MARK: Default Implementation
public extension Customizable {
    func apply(to target: inout Target) {
        for modifier in modifiers {
            _ = modifier.apply(to: &target)
        }
    }
}

// MARK: Self: Modifiable
public extension Customizable where Self: Modifiable {
    mutating func merge(into target: inout Target) {
        apply(to: &target)
        clearAllModifiers()
    }

    mutating func merge(on keyPath: WritableKeyPath<Self, Target>) {
        apply(to: &self[keyPath: keyPath])
        clearAllModifiers()
    }
}

public extension Customizable where Self: Modifiable, Self == Target {
    mutating func merge() {
        merge(on: \.self)
    }
}
