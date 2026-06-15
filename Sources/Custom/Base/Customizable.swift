//
//  Customizable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 27/09/2025.
//

/// Type that can store modifiers for altering a given target.
/// 
/// Can be used both as associated to an object or a list or to be applied into another element.
public protocol Customizable {
    /// Type that defines a collection of modifiers.
    /// 
    /// A type is considered self-customizable when `Modifiers.Element.Target = Self`.
    associatedtype Modifiers: Collection where Modifiers.Element: Modifier
    /// Target of a modifier.
    typealias Target = Modifiers.Element.Target
    /// Result of a modifier.
    typealias Output = Modifiers.Element.Output
    /// Modifiers associated with this element.
    var modifiers: Modifiers { get }
}

// MARK: Default Implementation
public extension Customizable {
    /// Applies modifiers onto a target.
    /// - Parameter target: Target to be modified.
    func apply(to target: inout Target) {
        for modifier in modifiers {
            _ = modifier.apply(to: &target)
        }
    }
}

// MARK: Self: Modifiable
public extension Customizable where Self: Modifiable {
    /// Applies modifiers onto a target, removing them from the list.
    /// - Parameter target: Target to be modified.
    mutating func merge(into target: inout Target) {
        apply(to: &target)
        clearAllModifiers()
    }
    /// Applies modifiers onto a property of itself, removing them from the list.
    /// - Parameter keyPath: Path to the property.
    mutating func merge(on keyPath: WritableKeyPath<Self, Target>) {
        apply(to: &self[keyPath: keyPath])
        clearAllModifiers()
    }
}

public extension Customizable where Self: Modifiable, Self == Target {
    /// Applies modifiers onto itself, removing them from the list.
    mutating func merge() {
        merge(on: \.self)
    }
}
