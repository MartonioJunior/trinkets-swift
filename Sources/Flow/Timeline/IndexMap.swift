//
//  IndexMap.swift
//  Trinkets
//
//  Created by Martônio Júnior on 30/08/2026.
//

import MatheRange
/// Continuous block composed from a collection of values.
public struct IndexMap<Element, Instant: Comparable> {
    /// Key used to map values with it's respective elements.
    public typealias Index = Int
    // MARK: Variables
    /// Collection of elements that compose this index map.
    var elements: [Index: Element]
    /// Fallback value used when the collection is empty.
    var fallback: Element
    /// Map of instants to indices.
    var map: [Entry]
    // MARK: Initializers
    /// Creates a new index map.
    /// - Parameters:
    ///   - elements: Collection of elements that compose this index map.
    ///   - fallback: Fallback value used when the collection is empty.
    ///   - map: Map of instants to indices.
    ///
    public init(_ elements: [Index: Element] = [:], fallback: Element, map: [Entry] = []) {
        self.elements = elements
        self.fallback = fallback
        self.map = map.sorted()
    }
    // MARK: Methods
    /// Removes a connection from the index map without removing the element it maps to.
    /// - Parameter instant: Instant to disconnect entries.
    /// 
    /// When a connection is cleared, it's predecessor takes over it's section.
    mutating func clear(_ instant: Instant) {
        guard let mapIndex = map.firstIndex(where: { $0.instant == instant }) else {
            return
        }

        map.remove(at: mapIndex)
    }
    /// Creates a new connection in the index map.
    /// 
    /// If an instant already has a connection, it is overwritten.
    /// - Parameters:
    ///   - instant: Instant to be marked.
    ///   - index: Index of the element the instant should be associated with.
    /// 
    /// The section occupied by a connection goes up until it's successor or until the end of the represented type
    /// in the case of the last element.
    mutating func connect(_ instant: Instant, index: Index?) {
        let newEntry = Entry(instant, to: index)

        if let mapIndex = map.firstIndex(where: { $0.instant == instant }) {
            map[mapIndex] = newEntry
        } else {
            map.append(newEntry)
        }
    }
    /// Fetches the entry section where a given instant lands.
    /// - Parameter instant: Initial instant.
    /// - Returns: Entry associated with the instant, `nil` when the map is empty.
    func entry(for instant: Instant) -> Entry? {
        map.last { $0.instant <= instant }
    }
    /// Registers a new element into the index map.
    /// - Parameters:
    ///   - element: Element to be added.
    ///   - index: Index where to add it.
    mutating func register(_ element: Element, at index: Index) {
        elements[index] = element
    }
    /// Removes an element from the index map.
    /// - Parameters:
    ///   - element: Element to be removed.
    ///   - clearMap: Should the instants associated with the element be removed?
    mutating func removeElement(at index: Index, clearMap: Bool = true) {
        elements.removeValue(forKey: index)

        guard clearMap else { return }

        map.removeAll { $0.index == index }
    }
}

// MARK: DotSyntax
public extension IndexMap {
    /// Creates an index map with only one element.
    /// - Parameters:
    ///   - element: Element representing the index map.
    static func ofOne(_ element: Element, _: Instant.Type = Instant.self) -> Self {
        .init([:], fallback: element, map: [])
    }
}

// MARK: Self.Entry
public extension IndexMap {
    /// Data structure used to associate intervals between instants with a value.
    struct Entry {
        /// Reference instant.
        var instant: Instant
        /// Index for the element associated with this section.
        var index: Index?
        /// Creates a new entry
        /// - Parameters:
        ///   - instant: Reference instant.
        ///   - index: Index for the element associated with this section.
        public init(_ instant: Instant, to index: Index? = nil) {
            self.instant = instant
            self.index = index
        }
    }
}

extension IndexMap.Entry: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.instant < rhs.instant
    }
}

extension IndexMap.Entry: Equatable {}

// MARK: Self: Boundary
extension IndexMap: Boundary {
    // swiftlint:disable:next missing_docs
    public typealias Bound = Instant
    // swiftlint:disable:next missing_docs
    public static func ~= (lhs: Self, rhs: Instant) -> Bool {
        lhs.entry(for: rhs)?.index != nil
    }
}

// MARK: Self: Block
extension IndexMap: Block {
    // swiftlint:disable:next missing_docs
    public var mask: Self { self }
    // swiftlint:disable:next missing_docs
    public func element(on instant: Instant) -> Element {
        guard let index = entry(for: instant)?.index, let element = elements[index] else { return fallback }

        return element
    }
}

// MARK: Self.Element: Optional
public extension IndexMap {
    /// Creates a new index map.
    /// - Parameters:
    ///   - elements: Collection of elements that compose this index map.
    ///   - fallback: Fallback value used when the collection is empty.
    ///   - map: Map of instants to indices.
    ///
    init<T>(_ elements: [Index: Element] = [:], map: [Entry] = []) where Element == T? {
        self.init(elements, fallback: nil, map: map)
    }
}
