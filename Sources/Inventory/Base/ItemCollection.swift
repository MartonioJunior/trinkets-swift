//
//  ItemCollection.swift
//  Trinkets
//
//  Created by Martônio Júnior on 05/01/2026.
//

import TrinketsUnits

/// Defines a Collection that can be initialized with a list of item contents.
/// 
/// Initialization is also compatible with `@ItemBuilder`, allowing declarative initialization:
/// ```swift
/// Chest {
///   coin * 50;
///   .weapon(.soldierSword(.rare));
///   forestZoneKey
/// }
/// ```
/// 
/// If your structure is compatible with multiple items, we recommend defining the associated type internally,
/// as it provides a more well-defined scope for the collection:
/// ```swift
/// struct Example: ItemCollection {
///   enum Item {
///     case currency(Currency)
///     case material(Material)
///     case weapon(Weapon)
///     // ...
///   }
/// }
/// ```
public protocol ItemCollection {
    /// Type of item accepted.
    associatedtype Item: Measurable
    /// Instances the storage with an existing list of contents.
    /// - Parameter contents: Contents of the inventory.
    init(_ contents: some Sequence<Measurement<Item, Tally>>)
}

// MARK: Default Implementation
public extension ItemCollection {
    /// Instances an empty storage.
    init() { self.init([]) }
    /// Instances the storage with an existing list of contents.
    /// - Parameter elements: Contents of the inventory.
    init(@ItemBuilder<Item> _ elements: () -> [Measurement<Item, Tally>]) {
        self.init(elements())
    }
}

// MARK: Self: ExpressibleByArrayLiteral
public extension ItemCollection where Self: ExpressibleByArrayLiteral {
    // swiftlint:disable:next missing_docs
    init(arrayLiteral elements: Measurement<Item, Tally>...) {
        self.init(elements)
    }
}
